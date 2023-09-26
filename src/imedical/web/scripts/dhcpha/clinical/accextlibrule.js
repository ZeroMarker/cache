/*
Creator:LiangQiang
CreatDate:2014-11-26
Description:函数项目维护
*/


var url='dhcpha.clinical.action.csp' ;

var currEditRow="";currEditID="";currPointer="";currLibDr=""

var libcbclumns=[[    
					  {field:'desc',title:'描述',width:150}, 
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
			//var ed=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'reasondr'});
			//$(ed.target).val(option.value);  //设置科室ID
			//var ed=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'usereason'});
			//$(ed.target).combobox('setValue', option.text);  //设置科室Desc

			//var text=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'text'});
			//alert(option.text)
		}
	}
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


///医生
var doccolumns=[[  
              {field:'code',title:'工号',width:200}, 
			  {field:'desc',title:'医生',width:200}, 
			  {field:'rowid',title:'rowid',hidden:true}
			  ]];

var tg = {
	url: url+'?action=QueryAccDocList',  //csp, 空为null
	columns: doccolumns,  //列信息
	pagesize:30,  //一页显示记录数
	table: '#docgrid', //grid ID
	field:'rowid', 
	params:null,
	tbar:'#doctorbar'

}

///医生科室
var docloccolumns=[[  
              {field:'code',title:'科室',width:200,hidden:true}, 
               {field:'desc',title:'科室',width:200}, //qunianpeng 2017/10/9
			  {field:'rowid',title:'rowid',hidden:true}
			  ]];

var docloctg = {
	url: url+'?action=QueryAccDocLocList',  //csp, 空为null
	columns: docloccolumns,  //列信息
	pagesize:30,  //一页显示记录数
	table: '#doclocgrid', //grid ID
	field:'rowid', 
	params:null,
	tbar:'#doclocbar'

}

///医院
var hospcolumns=[[  
              {field:'desc',title:'医院',width:200}, 
			  {field:'rowid',title:'rowid',hidden:true}
			  ]];

var hosptg = {
	url: url+'?action=QueryHospList',  //csp, 空为null
	columns: hospcolumns,  //列信息
	pagesize:30,  //一页显示记录数
	table: '#hospgrid', //grid ID
	field:'rowid', 
	params:null

}

///职称
var ctpcolumns=[[  
              {field:'desc',title:'职称',width:200}, 
			  {field:'rowid',title:'rowid',hidden:true}
			  ]];

var cpttg = {
	url: url+'?action=QueryCtCptList',  //csp, 空为null
	columns: ctpcolumns,  //列信息
	pagesize:30,  //一页显示记录数
	table: '#cptgrid', //grid ID
	field:'rowid', 
	params:null

}

var detailcolumns=[[  
			  {field:'desc',title:'项目',width:200}, 
			  {field:'relat',title:'关系',width:80,editor:relatcombo},
			  {field:'pri',title:'优先级',width:80, 
                    formatter:function(value,rec,index){    
                        var a = '<a href="#" mce_href="#" onclick="addconitm(\''+ rec.rowid + '\')">上移</a> ';
						var b = '<a href="#" mce_href="#" onclick="addconitm(\''+ rec.rowid + '\')">下移</a> ';
                        return a+b;  
                    }  
			  },
			  {field:'rowid',title:'rowid',hidden:true}
			  ]];


var detailtg = {
	url: null, //url+'?action=QueryLibRuleDs',  //csp, 空为null
	columns: detailcolumns,  //列信息
	pagesize:150,  //一页显示记录数
	table: '#detailgrid', //grid ID
	field:'rowid', 
	params:null

}

var itmclumns=[[ 
			  {field:'desc',title:'项目',width:200}, 
			  {field:'active',title:'关系',width:60},  
			  {field:'code',title:'代码',hidden:true},
			  {field:'fun',title:'函数表达式',hidden:true},
			  {field:'remark',title:'备注',width:80},
			  {field:'active',title:'启用',width:60},  
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
			  {field:'desc',title:'描述',width:200,formatter:title_formatter}, 
			  {field:'libdr',title:'libdr',hidden:true}, 
			  {field:'lib',title:'知识库',width:50}, 
			  {field:'ralation',title:'关系',hidden:true},   
			  {field:'rowid',title:'rowid',hidden:true},
			  {field:'id',title:'id',hidden:true},
			  {field:'_parentId',title:'parentId',hidden:true},
			  {field:'contrl',title:'控制',hidden:true},
			  {field:'chk',title:'选择',hidden:true}
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


    　$('#doctorno').bind('keydown',function(event){
		 if(event.keyCode == "13")    
		 {
			 
			 var input=$.trim($("#doctorno").val());
  
				$('#docgrid').datagrid('load',  {  
							action: 'QueryAccDocList',
							input:input
				});

		 }
　　　 });
		//科室回车事件 qunianpeng  2017/4/17
		$('#doclocbarid').bind('keydown',function(event){
		 if(event.keyCode == "13")    
		 {
			 
			 var input=$.trim($("#doclocbarid").val());
  
				$('#doclocgrid').datagrid('load',  {  
							action: 'QueryAccDocLocList',
							input:input
				});

		 }
　　　 });
       //知识库
	   libcomb=new ComboGrid(libcbg);
       libcomb.init(); 

	   var opt=$("#libcombo").combogrid('options');
	   opt.onSelect=function(){
		   var libdr= $('#libcombo').combogrid('grid').datagrid('getSelected').rowid;  
		   currLibDr=libdr;
		   
	   }

       //医生
	   docgrid = new DataGrid(tg);
	   docgrid.init();
	   
	   var opt=$("#docgrid").datagrid('options');
	   opt.onClickRow=function(rowIndex, rowData){
		   var pointer=rowData.rowid;
		   var input=currLibDr+"^"+pointer+"^"+"doc";
		   QueryAccitm(input);
	   }

　　　　//医生科室
	   doclocgrid = new DataGrid(docloctg);
	   doclocgrid.init();
	   
	   var opt=$("#doclocgrid").datagrid('options');
	   opt.onClickRow=function(rowIndex, rowData){
		   var pointer=rowData.rowid;
		   var input=currLibDr+"^"+pointer+"^"+"docloc";
		   QueryAccitm(input);
	   }

　　　　//医院
       hospgrid = new DataGrid(hosptg);
	   hospgrid.init(); 

	   var opt=$("#hospgrid").datagrid('options');
	   opt.onClickRow=function(rowIndex, rowData){

		   if (currLibDr=="")
		   {
			   		$.messager.alert('错误提示','知识库不能为空!',"error");
					return;
		   }
		   var pointer=rowData.rowid;
		   var input=currLibDr+"^"+pointer+"^"+"hosp";
		   QueryAccitm(input);
	   }
　　　　//职称
       cptgrid = new DataGrid(cpttg);
	   cptgrid.init();

	   var opt=$("#cptgrid").datagrid('options');
	   opt.onClickRow=function(rowIndex, rowData){
		   var pointer=rowData.rowid;
		   var input=currLibDr+"^"+pointer+"^"+"cpt";
		   QueryAccitm(input);
	   }



	   //项目grid  
	   funitmgrid = new TreeGrid(itmtg);
	   funitmgrid.init();


	   //授权grid  
	   accitmgrid = new TreeGrid(accitmtg);
	   accitmgrid.init();
	   $('#accitmgrid').datagrid('loadData', {total:0,rows:[]}); //qnp add 2017-4-13

	   var opt=$("#accitmgrid").treegrid('options');
	   opt.onClickRow=function(rowData){
	   }



	   opt.onClickRow=function(rowData){
             //加载完毕后获取所有的checkbox遍历

                 //让点击的行单选按钮选中
				  //var id="set_power_"+rowData.id;

                  //var val=document.getElementById(id);   //.value ;
				  //val.checked=!(val.checked);
           

       }

	


        //新增
	    $("#btnSave").click(function (e) { 

                SaveAcc();

        })
     





			 

}


//保存授权
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
    var chk_value =[];//定义一个数组    
	$('input[name="set_power"]:checked').each(function(){//遍历每一个名字为interest的复选框，其中选中的执行函数    
		alert($(this).val());//将选中的值添加到数组chk_value中  
		
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
		
	var nodeValue = $("#set_power_"+menu_id).val();	/// qunianpeng 2018/4/13 增加函数控制，1.父节点全选/反选 2.子节点选中，父节点自动选中
	var nodeArray = nodeValue.split("||");
	var rootNode = nodeArray[0];					/// 父节点value
	if (nodeArray.length == 1){						/// 父节点
		if($("#set_power_"+menu_id).is(':checked')){	/// 父节点选中，子节点全选
			$("input[name=set_power]").each(function(){	
				var chlidArray = this.value.split("||");
				if (chlidArray[0] == rootNode ){
					$('#'+this.id).attr("checked",'true'); 			
				}	
			});
		}else{
			$("input[name=set_power]").each(function(){	/// 父节点取消，子节点取消全选
				var chlidArray = this.value.split("||");
				if (chlidArray[0] == rootNode ){
					$('#'+this.id).removeAttr("checked"); 			
				}	
			});
		}	
	}else{												/// 子节点
		if($("#set_power_"+menu_id).is(':checked')){	/// 子节点选中时,自动选中根节点				
			$("input[name=set_power]").each(function(){	/// 遍历所有的input 找到父节点
				if (this.value == rootNode ){
					$('#'+this.id).attr("checked",'true'); 			
				}
			});
		}			
	}	
} 

///保存
function Save(input)
{            

			rq.url=url+'?action=SaveAccItm' ;
            rq.data={"input":input},
            ajax=new JRequest(rq);
            ajax.post(SaveCallback);



}

//保存回调
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

