/*
Creator:LiangQiang
CreatDate:2014-06-20
Description:函数项目维护
*/


var url='dhcpha.clinical.action.csp' ;
var itmTypeArr = [{ "val": "医嘱", "text": "医嘱" }, { "val": "检验", "text": "检验" }]   //wangxuejian 2016-09-20  函数项目维护的类型
//请求
var rq={
	url: url,  
	async:true,
	type:'json',
	data:null
}

var curfunrowid="";  //当前选择的函数库id
var curfunitmrowid=""; //当前选择的函数项目id
var type="";  //当前选择的函数项目类型  wangxuejian 2016-09-21

var funscolumns=[[  
			  {field:'desc',title:'描述',width:120}, 
			  {field:'code',title:'代码',width:80},
			  {field:'funtions',title:'函数表达式',width:200},
			  {field:'returnval',title:'返回值',width:80},
			  {field:'remark',title:'备注',width:80},
			  {field:'active',title:'启用',width:60},
			  {field:'rowid',title:'rowid',hidden:true},
			  {field:'_parentId',title:'parentId',hidden:true}
			  ]];

var tg = {
	url: url+'?action=QueryFuntionLib',  //csp, 空为null
	columns: funscolumns,  //列信息
	pagesize:150,  //一页显示记录数
	table: '#funtionsgrid', //grid ID
	field:'rowid', 
	treefield:'desc',
	params:null

}

var itmclumns=[[{field:'theme',title:'主题',width:180},
 			  {field:'code',title:'代码',width:100},
			  {field:'desc',title:'描述',width:160},
			  {field:'funtions',title:'函数表达式',width:100},
			 // {field:'arguments',title:'入参',width:100,hidden:true},
			  {field:'remark',title:'备注',width:100},
			  {field:'active',title:'启用',width:40,align:'center'},
			  {field:'type',title:'类型',width:40,align:'center'},  
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
					  {field:'desc',title:'主题',width:150}, 
					  {field:'itmdesc',title:'项目',width:150},
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

       
       //主题
	   themecomb=new ComboGrid(cbg);
       themecomb.init();
	   //函数库grid
	   fungrid = new TreeGrid(tg);
	   fungrid.init();  
	   fungrid.dblclickrow(ShowText);

	   //项目grid
	   funitmgrid = new DataGrid(dg);
	   funitmgrid.init();  
	   funitmgrid.clickrow(ShowItmText);

        //新增
	    $("#btnAdd").click(function (e) { 

                AddFunLib(1);

        })
     
        //更新
		$("#btnUpd").click(function (e) { 

                AddFunLib(2);

         })
         //清屏
         $("#btnClear").click(function(e){
	         ClearFunLib();
         })

        //药品
		$("#btnOpenDrugWin").click(function (e) { 

               //OpenDrugFunWin(curfunitmrowid);
               if (curfunitmrowid == ""){
	           	  	$.messager.alert('提示','请选择需添加参数监测项目后重试！','warning');
					return;
               }
	            if(type=="检验")    //wangxuejian 2016/10/24
	           {
		           $.messager.alert('提示','检验类型不能添加医嘱项目！','warning');
					return;
	           }
               createArtWin();

         })


		//检验
		$("#btnOpenLabWin").click(function (e) { 

               //OpenLabWin(curfunitmrowid);
               if (curfunitmrowid == ""){
	           	  	$.messager.alert('提示','请选择需添加参数监测项目后重试！','warning');
					return;
	           }
	           if(type=="医嘱")    //wangxuejian 2016/10/24
	           {
		           $.messager.alert('提示','医嘱类型不能添加检验指标！','warning');
					return;
	           }
               createLabWin();

         })
         
         initScroll();//初始化显示横向滚动条  //2014-09-16 bianshuai 解决列不显示问题
         
   //类型                       //2016-09-20 wangxuejian
	$('#itmtype').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:itmTypeArr
	});
}
//默认显示横向滚动条
function initScroll(){
	var opts=$('#funitemgrid').datagrid('options');   //返回属性对象 
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
	
///新增函数库
function AddFunLib(opflag)
{  

			if (opflag=="2")  //wangxuejian 2016-09-01
			{
				    
				    rowid=curfunitmrowid ;

					if (rowid=="")
					{
								$.messager.alert('错误提示','请先选择需要更新的函数项!',"error");
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
			var type=$('#itmtype').combobox('getValue'); //类型  获取里面的值 wangxuejian 2016-09-21
			
            var funtions=$.trim($("#funtions").val());
			//var arguments=$.trim($("#arguments").val());
			var remark=$.trim($("#remark").val());
			
			var theme="";  //主题
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
						$.messager.alert('错误提示','主题不能为空!',"error");
						return;
			}

			if (code=="")
			{
						$.messager.alert('错误提示','代码不能为空!',"error");
						return;
			}

			if (funtions=="")
			{
						$.messager.alert('错误提示','函数不能为空!',"error");
						return;
			}
			
			if (type=="")
			{
						$.messager.alert('错误提示','项目类型不能为空!',"error");
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
        
 //保存数据                                                               
	$.post(url+'?action=AddFunLibItem',{"input":input},function(data){     // wangxuejian 2016-09-12
		
		var jsonObj = $.parseJSON(data); //json格式转化  

		if(jsonObj.retvalue==0)
		{
	        $.messager.alert("提示","保存成功!");
		}
		if(jsonObj.retvalue==1)
		{
				$.messager.alert("错误提示","该项目已存在,保存失败!","error");
		}
		$('#funitemgrid').datagrid('reload'); //重新加载
	    $('#funitemgrid').datagrid('clearSelections') //wangxuejian 2016/10/24 
	    curfunitmrowid=""    //wangxuejian 2016/10/24
	    
	});
	 ajax=new JRequest(rq);
     ajax.post(AddFunLibCallback);



}

//新增回调
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
	
	$('#itmtype').combobox("clear");        //类型  wangxuejian 2016-09-21
	$('#itmtype').combobox('setValue',rowData.type)  //重新给他赋值
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

/// 添加医嘱项目
function createArtWin(){
	
	/// 查询窗口
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	new WindowUX('添加项目', 'newItmWin', '950', '550', option).Init();
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.funlibitmart.csp?funLibItmID='+curfunitmrowid+'&funLibItmType='+type+'&MWToken='+websys_getMWToken()+'"></iframe>'; //wanguejian   2016-09-21  传递参数
	$("#newItmWin").html(iframe);
}
/// 添加检验指标
function createLabWin(){
	
	/// 查询窗口
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	new WindowUX('添加项目', 'newItmWin', '950', '550', option).Init();
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.funlibitmlabart.csp?funLibItmID='+curfunitmrowid+'&funLibItmType='+type+'&MWToken='+websys_getMWToken()+'"></iframe>';
	$("#newItmWin").html(iframe);
}
function ClearFunLib(){
	 
	$("#code").val("");
	$("#desc").val("");
	$("#chkactive").attr("checked",false)//未选中
    $("#funtions").val("");
	$("#remark").val("");
	$('#itmtype').combobox("setValue",""); //类型      
	$("#themecombo").combogrid("clear");//主题	 
 }
 