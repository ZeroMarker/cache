
var init=function() {
	///////////////////////////////////////////////////////////////////////////////
	///组
	var browseGrid = $HUI.datagrid("#browseGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
			MethodName:"GetBdqCfgList",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
			searchV:"",
			wantreturnval:0
		},		
		idField:'ID',	//必须要设置这个属性！在调用getRowIndex时会用到
		columns:[[
			{field:'ID',title:'ID',width:100,align:'left',hidden:true},
			{field:'Name',title:'名称',width:100,align:'left',editor:'text'},
			{field:'Code',title:'编码',width:100,align:'left'},
			{field:'Descript',title:'描述',width:100,align:'left',editor:'text'},
			{field:'BusinessType',title:'业务类型',width:100,align:'left'},
			{field:'ShowType',title:'报表类型',width:100,align:'left'},
			{field:'SSUSR_Name',title:'创建人',width:100,align:'left',editor:'text'},
			{field:'QryName',title:'查询对象名称',width:100,align:'left'},
			{field:'QryCode',title:'查询对象编码',width:100,align:'left'},
			{field:'DSType',title:'查询对象类型',width:100,align:'left',hidden:true},
			
			{field:'action',title:'操作',width:70,align:'left',
				formatter:function(value,row,index){
					var rowdataid="\""+row.ID+"\"";		//datagrid的idField；
					var selector='"#browseGrid"';
					var s = "<a href='#' title='修改' class='hisui-tooltip' ><span class='icon icon-write-order'  onclick='init.editRec("+selector+','+rowdataid+",init.editCallback)'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;&nbsp;<a href='#' title='删除' class='hisui-tooltip' ><span class='icon icon-cancel'  onclick='init.removeRec("+selector+","+rowdataid+",init.deleteGrp)'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;&nbsp;<a href='#' title='预览' class='hisui-tooltip' ><span class='icon icon-copy-prn'  onclick='init.showPreview("+selector+","+rowdataid+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>";
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
				ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
				MethodName:"GetBdqCfgList",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
				searchV:value,
				wantreturnval:0
				
				});

		}
	})
	
	
	//$(".placeholder-element").next().css({"visibility":"hidden"});
	
	
}

var addRptCfg=function(showType){
	///modify by wz.2018-10-19
	var digHeight=500;
	var contentHeight=digHeight-40;
	var url = "dhcwl/v1/bkcdataquery/bdqrptcfg.csp?act='add'&rptID=''&showType='"+showType+"'";
	var redirectURL="dhcwlredirect.csp";
	var content = '<iframe frameborder="0" marginheight="0px" marginwidth="0px" scrolling="auto" seamless="seamless" src="'+redirectURL+'?url='+url+'" style="width:100%;height:100%;display:block;"></iframe>';
	//" frameborder="0" marginheight="0px" marginwidth="0px" scrolling="auto" seamless="seamless"  

 	$HUI.dialog("#swWin",{
		iconCls:'icon-w-add',
		title: '新增',
		width: 900,
		height: digHeight,
		closed: true,
		//cache: false,
		content:content,
		modal: true
	});	

	
	
	
	var act=4;
	if (act==0) $('#swWin').html(content);
	else if (act==1) $('#addRptDivFrame').html(content);
	else if (act==2) $('#addRptDivFrame').panel('open').panel('refresh',url);
	else if (act==3) {
		$('#addRptDivFrame').panel({
			content:content
		});		
	}




	$('#swWin').dialog('open');			

	
	
}
$(init);

//移除grid中的一行记录
init.removeRec=function(gridSelector,ID,funCallback) {
	$.messager.confirm("删除", "确定要删除数据吗?", function (r) { 
	if (r) { 
		
		$cm({
				ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
				MethodName:"DelRpt",
				wantreturnval:0,
				rptID:ID
			},function(jsonData){
					if (jsonData.success==1) {
						var searchV=$('#searchBtn').searchbox("getValue");
						$("#browseGrid").datagrid("reload",{
							ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
							MethodName:"GetBdqCfgList",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
							searchV:searchV,
							wantreturnval:0
							
						});
						
						showMsgByPop('操作成功！','success');					
						
					}else{
						$.messager.alert("提示",jsonData.msg);
					}
					

		});	

	}
	})
}





//删除
init.deleteGrp=function(ID) {
                                                
	$cm({
			ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
			MethodName:"delGrp",
			wantreturnval:0,
			ID:ID
		},function(jsonData){
			
			$('#grpDataGrid').datagrid('reload',{
				ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
				MethodName:"GetBdqCfgList",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
				searchV:value,
				wantreturnval:0
				
			});
			if (jsonData.success==1) {
			}else{
				$.messager.alert("提示",jsonData.msg);
			}
				

		});

}

init.editCallback=function(rowData) {

}

init.editRec=function(gridSelector,ID,funCallback) {
	
	var index=$(gridSelector).datagrid("getRowIndex",ID);
	var showType=$(gridSelector).datagrid("getData").rows[index].ShowType;
	
	var digHeight=500;
	var contentHeight=digHeight-40;
		
	url = "dhcwl/v1/bkcdataquery/bdqrptcfg.csp?act='edit'&rptID="+ID+"&showType='"+showType+"'";
	var redirectURL="dhcwlredirect.csp";
	var content = '<iframe frameborder="0" src="'+redirectURL+'?url='+url+'" style="width:100%;height:100%;display:block;"></iframe>';
	
 	$HUI.dialog("#swWin",{
		iconCls:'icon-w-add',
		title: '修改',
		width: 900,
		height: digHeight,
		closed: true,
		//cache: false,
		content:content,
		modal: true
	});	

	$('#swWin').dialog('open');		
	
	
	
	
	
	
	//parent.$('#iframeContext').html(content);
};	

///结束编辑
init.endEditing=function(gridSelector,ID,funCallback){
	if (init[gridSelector].editID == undefined){return true}
	//var editIndex=$(gridSelector).datagrid("getRowIndex",ID);
	var editIndex=$(gridSelector).datagrid("getRowIndex",init[gridSelector].editID);
	if ($(gridSelector).datagrid('validateRow', editIndex)){
		$(gridSelector).datagrid('endEdit',editIndex);
		///
		var rowData=$(gridSelector).datagrid('getRows')[editIndex];
		funCallback(rowData);
		///
		init[gridSelector].editID = undefined;
		return true;                                                                                
	} else {
		return false;                                                                               
	}                                                                                             
}; 
init["#grpDataGrid"]={editID:undefined}


init.showPreview=function(gridSelector,ID)
{
	if (1) {
		var index=$(gridSelector).datagrid("getRowIndex",ID);
		var DSType=$(gridSelector).datagrid("getData").rows[index].DSType
		var Name=$(gridSelector).datagrid("getData").rows[index].Name;
		
		var rptTool="";
		if (DSType=="主题") {
			rptTool="BaseDataQuery";
		}else if (DSType=="指标") {
			rptTool="KpiDataQuery";
		}
		
		var url="dhcwl/v1/bkcdataquery/bkcdataqryview.csp?rpttool="+rptTool+"&rptid="+ID;
		var productID=rptTool+'-'+ ID;
		
		if (window.opener && !window.opener.closed) {
			var title=Name;
			var realUrl = "dhcwlredirect.csp?url=" + url;
			if (window.opener.productWindowOpen.hasOwnProperty(productID)){
				obj = window.opener.productWindowOpen[productID];
				if (!obj.closed){
					obj.focus();
					return;
				}
			}

			var obj = window.open(realUrl,title,' left=20,top=20,width='+ (window.opener.screen.availWidth - 60) +',height='+ (window.opener.screen.availHeight-90) +',scrollbars,resizable=no,toolbar=no,depended=yes,menubar=no,location=no, status=no');
			window.opener.productWindowOpen[productID] = obj;							 
								 
		}		
	}else{
		var index=$(gridSelector).datagrid("getRowIndex",ID);
		var DSType=$(gridSelector).datagrid("getData").rows[index].DSType
		var Name=$(gridSelector).datagrid("getData").rows[index].Name;
		var curQryObj={
			DSType:DSType,
			Name:Name,
			ID:ID
		};
		
		
		
		var rptTool="";
		if (curQryObj.DSType=="主题") {
			rptTool="BaseDataQuery";
		}else if (curQryObj.DSType=="指标") {
			rptTool="KpiDataQuery";
		}
		//var windowHeight=window.parent.parent.innerHeight;
		//取到父窗口的原始：window.parent.$HUI
		//var tabs=window.parent.parent.$HUI.tabs("#maintabs");
		var tabs=window.parent.$HUI.tabs("#homepage");
		var TAB_CONTTEMP=[
		    '<iframe id="',
		    , 
		    '"name="',
		    , 
		    '" frameborder="0" marginheight="0px" marginwidth="0px" scrolling="auto" seamless="seamless"  src="',
		    , 
		    '" height="',
		    , 
		    'px" width="',
		    , 
		    '"></iframe>'
		  ];
		TAB_CONTTEMP[7]=window.parent.innerHeight;
		TAB_CONTTEMP[9]="100%";		
		
		var previewURL="dhcwl/v1/bkcdataquery/bkcdataqryview.csp?rpttool="+rptTool+"&rptid="+curQryObj.ID;

		var openTab=tabs.getTab(curQryObj.Name);
		
		
		TAB_CONTTEMP[1]=curQryObj.ID;
		TAB_CONTTEMP[3]=curQryObj.ID;
		TAB_CONTTEMP[5]="/dthealth/web/csp/dhcwlredirect.csp?url="+previewURL;
		var tabcontent=TAB_CONTTEMP.join('');

		tabOptions={
					"id":curQryObj.ID,
					"selected":true,
					"closable":true,
					"cache":false,
					"width":"auto",
					"title":curQryObj.Name,
					"content":tabcontent
				};
				
		if(tabs.exists(curQryObj.Name)){
			tabs.update({
				tab:tabs.getTab(curQryObj.Name),
				options: tabOptions
			});
			tabs.select(curQryObj.Name);
			return true;
		}else{
			tabs.add(tabOptions);
		}				
	}
}			

