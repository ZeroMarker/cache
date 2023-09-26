/*
Creator:LiangQiang
CreatDate:2014-06-20
Description:用药监控查询
*/
var url='dhcpha.clinical.action.csp';
function BodyLoadHandler()
{
    InitDate();
	$('#querypanel').panel({   
		//width:500,   
		//height:150, 
		//title:'查询列表', 
		tools:[{     
			    iconCls:'icon-add',   
				handler:function(){alert('new')} 
			 },{      
				iconCls:'icon-save',  
				handler:function(){alert('save')}  
			  }]
	});

	$('#gridpanel').panel({   
		//width:500,   
		//height:150, 
		title:'列表', 
		tools:[{     
			    iconCls:'icon-add',   
				handler:function(){alert('new')} 
			 },{      
				iconCls:'icon-save',  
				handler:function(){alert('save')}  
			  }]
	});

	$('#themecombo').combogrid({ 
				  url:url+"?action=QueryFunLibTheme&page=1&rows=150"+"&input=Y", 
				  valueField:'rowid',
				  panelWidth:250,
				  idField:'rowid',
				  textField:'desc',
				  fitColumns: true,  
				  multiple:false, 
				  columns:[[    
					  {field:'desc',title:'描述',width:150}, 
					  {field:'rowid',title:'rowid',width:50} 
				  ]],
				 onLoadSuccess:function(){

					//  LoadRouteData();

				  }

	 });

	$('#patgrid').datagrid({
		fit:true,
		//fitColumns:true,
		singleSelect:true,
		idField:'patadm', 
		//nowrap: false,
		//striped: true,
		url:'', 
		pagination:true,
		rownumbers:true,//行号 
		width:300,
		pageSize:150,
		pageList:[150,300],
		columns:[[  
			{field:'patno',title:'登记号',width:100,
				formatter:fomartShowPatInfo
			}, 
			{field:'patname',title:'姓名',width:100},   
			{field:'patsex',title:'性别',width:60},
			{field:'patage',title:'年龄',width:60},
			{field:'patloc',title:'科室',width:100},
			{field:'patward',title:'病区',width:200},
			{field:'patH',title:'身高',width:60},
			{field:'patW',title:'体重',width:60},
			{field:'patdiag',title:'诊断',width:120},
			{field:'patdate',title:'入院日期',width:120},
			{field:'theme',title:'主题',width:100},
			{field:'patadm',title:'adm',width:80} 
		]],
		onClickRow:function(rowIndex, rowData){ 
			var patadm=rowData.patadm;
			FindInPatOrdItemList(patadm);
		}
	});
		
		$('#comborecloc').combogrid({  
			panelWidth:250,   
			idField:'ctlocdr',  
			textField:'ctloc', 
			//url:'datagrid_data.json', 
			columns:[[    
				{field:'ctloc',title:'Code',width:150},  
				{field:'ctlocdr',title:'Name',width:50}
			]]});



		$("#btnFind").click(function (e) { 
             FindPatList();
         })

		$("#btnNo").click(function (e) { 

            var adm="";
		   	var row=$('#patgrid').datagrid('getSelected');
			if (row)
			{
				adm=row.patadm ;
			}
			else{
				$.messager.alert('错误提示','请先选择一行记录!',"error");
				return;
			}
            GetAdmReaDs(adm);
         })
     
		 var href="dhcpha.clinical.adminorditem.csp";
	     var content = '<iframe scrolling="yes" frameborder="0"  src="'+href+'" style="width:100%;height:100%;"></iframe>';
         addtab("用药明细",content);
		 //var href="epr.newfw.episodelistuvpanel.csp";
	     //var content = '<iframe scrolling="yes" frameborder="0"  src="'+href+'" style="width:100%;height:100%;"></iframe>';
         //addtab("电子病历",content);
	     //$('#tabpanel').tabs('select',content);
	     //var href="epr.newfw.episodelistuvpanel.csp";
	     //var content = '<iframe scrolling="yes" frameborder="0"  src="'+href+'" style="width:100%;height:100%;"></iframe>';
         //addtab("过敏记录",content);
	     //var href="epr.newfw.episodelistuvpanel.csp";
	     //var content = '<iframe scrolling="yes" frameborder="0"  src="'+href+'" style="width:100%;height:100%;"></iframe>';
         //addtab("检查记录",content);
	     //$('#tabpanel').tabs('select',content);
         //var href="epr.newfw.episodelistuvpanel.csp";
	     //var content = '<iframe scrolling="yes" frameborder="0"  src="'+href+'" style="width:100%;height:100%;"></iframe>';
         //addtab("检验记录",content);
	     

		 //$('#tabpanel').tabs('select',"用药明细");
		 
	//默认显示横向滚动条   //2014-08-22 bianshuai
	function initScroll(){
		var opts=$('#patgrid').datagrid('options');    
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
		$('#patgrid').datagrid('loadData',data);
		$("tr[datagrid-row-index='0']").css({"visibility":"hidden"});
	}
	initScroll();//初始化显示横向滚动条  //2014-08-22 bianshuai
	
	//主题    //2014-08-22 bianshuai
	$('#theme').combobox({
		onShowPanel:function(){
			$('#theme').combobox('reload',url+'?action=SelAllTheme')
		}
		//panelHeight:"auto",  //设置容器高度自动增长
		//url:url+'?actiontype=SelAllLoc' 
	}); 
}


//标志原因
function saveRea(ret)
{
		var row=$('#patgrid').datagrid('getSelected');
		if (row)
		{
			var adm=row.patadm ;
			save(adm,ret);
		}
		else{
						$.messager.alert('错误提示','请先选择一行记录!',"error");
						return;
		}


}

//保存
function save(adm,ret)
{
            if (ret=="")
            {
				return;
            }
		    var user=session['LOGON.USERID'] ;
			var input=user+"^"+adm+"^"+ret;
			var data = jQuery.param({ "action":"SaveReaForMon","input":input});

			var request = $.ajax({
				url: url,
				type: "POST",
				async: true,
				data: data,
				dataType: "json",
				cache: false,
				success: function (r, textStatus) {
                     if (r)
                     {
						 ret=r.retvalue; 
                         
						 if (ret=="0")
						 {
							$.messager.alert('操作提示','保存成功!',"info");

						 }else{

						 }
                     }
					
		                    
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) { 
					  //alert(XMLHttpRequest.readyState); 
					}

			    });

}


function addtab(text,content){

	 $('#tabpanel').tabs('add',{ 
	   title:text, 
	   closable:true,
	   border:false,
	   content:content, 
	   fit:true,
	   tools:[{     
		  iconCls:'icon-mini-refresh',  
		   handler:function(){    
				   alert('refresh');    
					   }   
			 }]
	 });
}


function InitDate()
{
   var curr_time = new Date();  
   var strDate = curr_time.getFullYear()+"-";
   strDate += curr_time.getMonth()+1+"-";
   strDate += curr_time.getDate();  //+"-";  

   //strDate += curr_time.getHours()+":";  
   //strDate += curr_time.getMinutes()+":";  
   //strDate += curr_time.getSeconds();  
   $("#orderstdate").datebox("setValue", strDate);
   $("#orderenddate").datebox("setValue", strDate);
}
///查询病人用药列表
function FindPatList()
{
	var ordstdate=$('#orderstdate').datebox('getValue'); 
	var orderenddate=$('#orderenddate').datebox('getValue'); 
	if (ordstdate=="")
	{ $.messager.alert('错误提示','医嘱开始日期不能为空!',"error");
	  return;
	  }

	if (orderenddate=="")
	{ $.messager.alert('错误提示','医嘱结束日期不能为空!',"error");
	  return;
	  }

	var result="" //$('#comboresult').combobox('getValue');;  //状态
			/*
			var resultgrid=$("#comboresult").combogrid("grid");//
			var rows  = resultgrid.datagrid('getSelections');//
			for(var i=0; i<rows.length; i++){
					var row = rows[i];
					var rowid=row.rowid ;
					if (result=="")
					{
						result=rowid;
					}else{
						result=result+","+rowid ; 
					}

			}
			*/
    var ThemeID=$('#theme').combobox('getValue'); //主题ID
	var params=ordstdate+"^"+orderenddate+"^"+result+"^"+ThemeID ;
	//修改加载方式 bianshuai 2014-08-22
	$('#patgrid').datagrid({
		url:url+'?action=QueryMonInPatList',	
		queryParams:{
			params:params}
	});
}

//单击事件
function FindInPatOrdItemList(patadm)
{
	var ordstdate=$('#orderstdate').datebox('getValue'); 
	var orderenddate=$('#orderenddate').datebox('getValue'); 

	if (ordstdate=="")
	{
		$.messager.alert('错误提示','医嘱开始日期不能为空!',"error");
		return;
	}

	if (orderenddate=="")
	{
		$.messager.alert('错误提示','医嘱结束日期不能为空!',"error");
		return;
	}

	input=ordstdate+"^"+orderenddate+"^"+patadm;

	var tab = $('#tabpanel').tabs('getSelected');
	var index = $('#tabpanel').tabs('getTabIndex',tab);
	if (index==0)  ///查询住院病人用药明细
	{
		var href="dhcpha.clinical.adminorditem.csp?input="+input;
		var content = '<iframe scrolling="yes" frameborder="0"  src="'+href+'" style="width:100%;height:100%;"></iframe>';
	}
	updateTab(content);
}

//刷新tabs
function updateTab(content)
{
	var tab = $('#tabpanel').tabs('getSelected');
	$("#tabpanel").tabs('update', {
	tab: tab, 
　　　　　　options: {
		   content:content
		}
	}); 
	tab.panel('refresh');
}

function showPatInfo(adm)
{
	createPatInfoWin(adm);
}

function  fomartShowPatInfo(value,rowData,rowIndex)
{ 
   return "<a href='#' mce_href='#' onclick='showPatInfo("+rowData.patadm+");'>"+rowData.patno+"</a>";
} 

///获取原因
function GetAdmReaDs(adm)
{
	var ret="";
	var input=adm;
	var _json = jQuery.param({ "action":"GetAdmReaDs","input":input});
	var request = $.ajax({
		url: url,
		type: "POST",
		async: false,
		data: _json,
		dataType: "text",
		cache: false,
		success: function (r, textStatus) {
			reason = $.parseJSON(r);
			AddReaWindow(adm,reason,saveRea);
		},
		error: function (XMLHttpRequest, textStatus, errorThrown) { 
			//alert(XMLHttpRequest.readyState); 
		}
	});
	return 
}
