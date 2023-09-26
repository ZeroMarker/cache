/*
Creator:LiangQiang
CreatDate:2014-09-20
Description:剂型字典维护
*/
var url='dhcpha.clinical.action.csp' ;

var mainrowid="";
var columns =[[  
              {field:'code',title:'代码',width:180},
			  {field:'desc',title:'描述',width:180}, 
			  {field:'type',title:'类型',width:40}, 
			  {field:'active',title:'启用',width:40},
			  {field:'rowid',title:'rowid',width:40}
			  ]];

var uomgrid;
var ajax;
var dg = {
	url: url+'?action=QueryExtUomList&input=Y',  //csp, 空为null
	columns: columns,  //列信息
	pagesize:150,  //一页显示记录数
	table: '#uomgrid', //grid ID
	field:'rowid', //记录唯一标识
	params:null,  // 请求字段,空为null
	tbar:'#uomgridbar' //上工具栏,空为null

}


//请求rq
var rq={
	url: url,  
	async:true,
	type:'json',
	data:null
}



var hiscolumns =[[  
              {field:'code',title:'代码',width:120},
			  {field:'desc',title:'描述',width:120},
			  {field:'fac',title:'比例',width:80,editor : {  
                       type : 'numberbox',  
                        options : {  
                            required : true  
                        }  
                    }} ,  

			  {field:'fac',title:'比例',width:80,editor : {  
                       type : 'numberbox',  
                        options : {  
                            required : true  
                        }  
                    }} , 
			  {field:'rowid',title:'rowid',hidden:true},
			  {field:'opt',title:'操作',width:60,align:'center', 
                   formatter:function(value,rec,index){    
                        var e = '<a href="#" mce_href="#" onclick="addconitm(\''+ rec.rowid + '\')">对照</a> ';
                        return e;  
                    }  
              }
			  ]];

var hisuomgrid;
var hisdg = {
	url: url+'?action=QueryHisUom',  //csp, 空为null
	columns: hiscolumns,  //列信息
	pagesize:50,  //一页显示记录数
	table: '#hisuomgrid', //grid ID
	field:'rowid', //记录唯一标识
	params:null,  // 请求字段,空为null
	tbar:'#hisgridbar' //上工具栏,空为null

}

var concolumns =[[  
			  {field:'opt',title:'操作',width:60,align:'center', 
                   formatter:function(value,rec,index){    
                        var e = '<a href="#" mce_href="#" onclick="delconitm(\''+ rec.rowid + '\')">删除</a> ';
                        return e;  
                    }  
              },
              {field:'code',title:'代码',width:100},
			  {field:'desc',title:'描述',width:100},
			  {field:'hiscode',title:'his代码',width:100}, 
			  {field:'hisdesc',title:'his描述',width:100}, 
			  {field:'rowid',title:'rowid',hidden:true}

			  ]];

var conuomgrid;
var condg = {
	url: url+'?action=QueryUomCon',  //csp, 空为null
	columns: concolumns,  //列信息
	pagesize:150,  //一页显示记录数
	table: '#congrid', //grid ID
	field:'rowid', //记录唯一标识
	params:null,  // 请求字段,空为null
	tbar:null //上工具栏,空为null

}

function delconitm(rowid)
{
   $.messager.confirm('提示', '您确定撤消此条对照吗?', function(r){
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
﹛﹛   conuomgrid = new DataGrid(condg);
       conuomgrid.init(); 

	   //
﹛﹛   hisuomgrid = new DataGrid(hisdg);
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



//回调
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
					 $.messager.alert('操作提示','不能重复增加!',"error");
					 return;

				 }
				 $.messager.alert('操作提示','更新失败!',"error");
			 }
          
		 }else{
				 $.messager.alert('操作提示','连接失败!',"error");
		 }

}


//刷新
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








