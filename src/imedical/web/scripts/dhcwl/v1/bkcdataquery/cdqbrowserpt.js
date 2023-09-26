
var init=function() {
	///////////////////////////////////////////////////////////////////////////////

	var browseGrid = $HUI.datagrid("#browseGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.BKCDQry.CommonDataServ",
			MethodName:"GetCdqCfgList",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
			searchV:"",
			wantreturnval:0
		},		
		idField:'ID',	//必须要设置这个属性！在调用getRowIndex时会用到
		columns:[[
			{field:'ID',title:'ID',width:100,align:'left',hidden:true},
			{field:'Code',title:'编码',width:60,align:'left'},
			{field:'RptName',title:'名称',width:100,align:'left'},
			{field:'Descript',title:'描述',width:100,align:'left'},
			{field:'SSUSR_Name',title:'创建人',width:70,align:'left'},
			{field:'NameSpace',title:'NameSpace',width:70,align:'left'},
			{field:'Routine',title:'Routine',width:100,align:'left'},
			{field:'Fun',title:'Function',width:100,align:'left'},
			{field:'OtherParam',title:'其他参数',width:60,align:'left'},
			{field:'PdtType',title:'业务类型',width:50,align:'left'},
			{field:'action',title:'操作',width:60,align:'left',
				formatter:function(value,row,index){
					var rowdataid="\""+row.ID+"\"";		//datagrid的idField；
					var selector='"#browseGrid"';
					var s = "<a href='#' title='修改' class='hisui-tooltip' ><span class='icon icon-write-order'  onclick='init.editRec("+selector+','+rowdataid+",null)'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;&nbsp;<a href='#' title='删除' class='hisui-tooltip' ><span class='icon icon-cancel'  onclick='init.removeRec("+selector+","+rowdataid+",null)'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>";
					return s;
				}  
			}
			
	    ]],

		pagination:true,
		pageSize:15,
	    pageList:[5,10,15,20,50,100],
	    
		fit:true,
		fitColumns:true,
		onAfterEdit:function(rowIndex, rowData, changes) {
		
		}
	});	
	
	

	//查询报表
		///主界面查询响应方法
	$('#searchBtn').searchbox({
		searcher:function(value){
			$('#browseGrid').datagrid('load',{
				ClassName:"web.DHCWL.V1.BKCDQry.CommonDataServ",
				MethodName:"GetCdqCfgList",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
				searchV:value,
				wantreturnval:0
				
				});

		}
	})
	
}

$(init);

//移除grid中的一行记录
// init.editRec("+selector+','+rowdataid+",null)
init.editRec=function(gridSelector,ID,funCallback)
{
	/*
	var rowIndex=$(gridSelector).datagrid("getRowIndex",ID);
	var rptInfo=$(gridSelector).datagrid("getData")[rowIndex];
	
	var url = "dhcwl/v1/bkcdataquery/commondatacfg.csp?act='edit'&rptID="+ID;
	url = "/dthealth/web/csp/dhcwlredirect.csp?url="+url
	window.location.href = url;
	*/
	
	/*
	var digHeight=500;
	var url = "dhcwl/v1/bkcdataquery/commondatacfg.csp?act='edit'&rptID="+ID;
	*/
	var digHeight=500;
	var url = "dhcwl/v1/bkcdataquery/commondatacfg.csp?act='edit'&rptID="+ID;

	var contentHeight=digHeight-40;
	var redirectURL="dhcwlredirect.csp";	
	
	var content = '<iframe scrolling="no" frameborder="0" marginheight="0px" marginwidth="0px" seamless="seamless" src="'+redirectURL+'?url='+url+'" style="width:100%;height:100%;display:block;"></iframe>';


 	var editDlg=$HUI.dialog("#editDlg",{
		iconCls:'icon-w-add',
		title: '修改',
		width: 1078,
		height: digHeight,
		closed: true,
		content:content,
		modal: true
	});	

	$('#editDlg').dialog('open');
	//editDlg.location.href = url;	
	/*
	$('#editDlg').window('open'); 
	$('#editDlg').location.href = url;
	*/	
}

var addRptCfg=function() {
	/*	//modify by wz.2018-10
	var url = "dhcwl/v1/bkcdataquery/commondatacfg.csp?act='add'&rptID=''";
	url = "/dthealth/web/csp/dhcwlredirect.csp?url="+url
	window.location.href = url;		
	*/
///modify by wz.2018-10-19
	
	/*
	var digHeight=500;
	var url = "dhcwl/v1/bkcdataquery/commondatacfg.csp?act='add'&rptID=''";

 	$HUI.dialog("#editDlg",{
		iconCls:'icon-w-add',
		title: '新增',
		width: 1078,
		height: digHeight,
		closed: true,
		modal: true
	});	

	$('#editDlg').panel('open').panel('refresh',url);
	*/
	
	var digHeight=500;
	var url = "dhcwl/v1/bkcdataquery/commondatacfg.csp?act='add'&rptID=''";

	var contentHeight=digHeight-40;
	//var content = '<iframe frameborder="0" src="/dthealth/web/csp/dhcwlredirect.csp?url='+url+'" style="width:100%;height:'+contentHeight+'px;"></iframe>';
	var redirectURL="dhcwlredirect.csp";
	var content = '<iframe scrolling="no" frameborder="0" marginheight="0px" marginwidth="0px" seamless="seamless" src="'+redirectURL+'?url='+url+'" style="width:100%;height:100%;display:block;"></iframe>';

	
 	$HUI.dialog("#editDlg",{
		iconCls:'icon-w-add',
		title: '新增',
		width: 1078,
		height: digHeight,
		closed: true,
		content:content,
		modal: true
	});	

	$('#editDlg').dialog('open');	

}

//移除grid中的一行记录
init.removeRec=function(gridSelector,ID,funCallback) {
	$.messager.confirm("删除", "确定要删除数据吗?", function (r) { 
	if (r) { 
		
		$cm({
				ClassName:"web.DHCWL.V1.BKCDQry.CommonDataServ",
				MethodName:"DelRpt",
				wantreturnval:0,
				rptID:ID
			},function(jsonData){
					if (jsonData.success==1) {
						var searchV=$('#searchBtn').searchbox("getValue");
						$(gridSelector).datagrid("reload",{
							ClassName:"web.DHCWL.V1.BKCDQry.CommonDataServ",
							MethodName:"GetCdqCfgList",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
							searchV:searchV,
							wantreturnval:0
							
						});
					}else{
						$.messager.alert("提示",jsonData.msg);
					}
					

		});	
	}
	})
}