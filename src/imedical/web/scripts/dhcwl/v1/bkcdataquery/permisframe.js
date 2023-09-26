


var init=function() {
/*
var cboRptType = $HUI.combobox("#cboRptType",{                                                                                      
	valueField:'value',textField:'text',multiple:false,selectOnNavigation:false,panelHeight:"auto",editable:false,           
	data:[                                                                                                               
		{value:'bdq',text:'基础数据查询报表'},
		{value:'cdq',text:'简单数据查询报表'},
		{value:'adq',text:'所有类型'}  
	]})	
*/

/*
var cboItems = $HUI.combobox("#cboItems",{                                                                                      
	valueField:'id',textField:'text',multiple:true,selectOnNavigation:false,panelHeight:"auto",editable:false,           
	data:[                                                                                                               
		{id:'rpt',text:'报表'},{id:'grp',text:'组'},{id:'user',text:'人员'}                                        
	],                                                                                                                   
	formatter:function(row){                                                                                             
		var opts;                                                                                                          
			if(row.selected==true){   
				opts = "<input type='checkbox' checked='checked' id='r"+row.id+"' value='"+row.id+"'>"+row.text;                 
			}else{                                                                                                             
				opts = "<input type='checkbox' id='r"+row.id+"' value='"+row.id+"'>"+row.text;                                   
			}                                                                                                                  
			return opts;                                                                                                       
		},                                                                                                                   
		onSelect:function(rec) {                                                                                             
			var objr =  document.getElementById("r"+rec.id);                                                                   
			$(objr).prop('checked',true);                                                                                      
		},onUnselect:function(rec){                                                                                          
			var objr =  document.getElementById("r"+rec.id);                                                                   
			$(objr).prop('checked',false);                                                                                     
		}                                                                                                                    
	}); 
*/

	var cboItems = $HUI.combobox("#cboItems",{
		valueField:'id',
		textField:'text',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'rpt',text:'报表'},{id:'grp',text:'组'},{id:'user',text:'人员'}                                        
		]
	});
		
	///////////////////////////////////////////////////////////////////////////////
	///报表列
	var browseDataGrid = $HUI.datagrid("#browseDataGrid",{
		url:$URL,
		pagination:true,
		pageSize:15,
	    pageList:[5,10,15,20,50,100],
	    fit:true,
		fitColumns:true,
		onLoadSuccess: onbrowseLoadSuccess,
		queryParams: {
			ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
			QueryName:"GetMapCfg",		
			rptTool:"",
			mapItem:"",
			searchV:""
		}			
	});
	
	function onbrowseLoadSuccess(data) {

		if (data.total<=0) return;
		var mergeDatas=[];
		
		var opts = $(this).datagrid('getColumnFields');
		for(var col=0;col<opts.length;col++){
			//mergecells(this,data,beginRow,endRow,opts[col])
			if (col==0) {
				mergecells(this,data,0,data.rows.length-1,col,mergeDatas);
			}else{
				
				if (undefined==mergeDatas[opts[col-1]]) continue;
				var cnt=mergeDatas[opts[col-1]].length;
				for (var i=0;i<cnt;i++){
					var beginRow=mergeDatas[opts[col-1]][i].index;
					var endRow=beginRow+mergeDatas[opts[col-1]][i].rowspan-1;
					mergecells(this,data,beginRow,endRow,col,mergeDatas);
				}
			}
		}
		
		
		for(var x in mergeDatas) {
			for(var y in mergeDatas[x]) {
				$(this).datagrid('mergeCells',{
					index: mergeDatas[x][y].index,
					field: x,
					rowspan: mergeDatas[x][y].rowspan
				})
			}
				
		};
				
	
	};
	

	function mergecells(selector,data,beginRow,endRow,colInx,mergeDatas) {
		var opts = $(selector).datagrid('getColumnFields');
		var colName=opts[colInx];
		var lastCell=data.rows[beginRow][colName];
		var mStRow=beginRow;
		var mEndRow=beginRow;
		
		for(var row=beginRow+1;row<=endRow;row++) {
			if (lastCell!=data.rows[row][colName] || row==endRow && lastCell==data.rows[row][colName]) {
				if (row==endRow && lastCell==data.rows[row][colName]) mEndRow=row;
				//合并
				if (mEndRow-mStRow>0) {
					var mObj={
						index:mStRow,
						rowspan:mEndRow-mStRow+1
					}
					if (undefined==mergeDatas[colName]) {
						//mergeDatas.push(colName);
						mergeDatas[colName]=[];
					}
					mergeDatas[colName].push(mObj);
				}	
				//重置
				lastCell=data.rows[row][colName]
				mStRow=row;
				mEndRow=row;
									
			}else{
				//重置合并的开始和结束行
				mEndRow=row;
			}
			
		}
	}
		
	
	
	
	var rptCol=[
			{field:'rptID',title:'ID',width:100,align:'left',hidden:true},
			{field:'rptName',title:'报表名称',width:100,align:'left'},
			{field:'rptCode',title:'报表编码',width:100,align:'left'}
		];
	var grpCol=[
			{field:'grpID',title:'ID',width:100,align:'left',hidden:true},
			{field:'grpName',title:'组名称',width:100,align:'left'}
		
		];
	var memberCol=[
			{field:'userID',title:'人员ID',width:100,align:'left'},
			{field:'userName',title:'人员姓名',width:100,align:'left'}
		];

	$("#browseDataGrid").datagrid({
		columns:[rptCol.concat(grpCol.concat(memberCol))]
	});
	/*
	$("#browseDataGrid").data("rptCol",rptCol);
	$("#browseDataGrid").data("grpCol",grpCol);
	$("#browseDataGrid").data("memberCol",memberCol);
	*/
	
	
	var showRptGrpCfg=function()
	{
		var url = "dhcwl/v1/bkcdataquery/permisrptgrpmap.csp";
		var title="报表-组配置";
		showXCfg(url,title);
	}

	var showGrpCfg=function()
	{
		var url = "dhcwl/v1/bkcdataquery/permisgrpcfg.csp";
		var title="组配置";
		showXCfg(url,title);
	}
	
	
	var showGrpMemberCfg=function()
	{
		var url = "dhcwl/v1/bkcdataquery/permisgrpmembermap.csp";
		var title="组-人员配置";
		showXCfg(url,title);
	}
	
	var showXCfg=function(url,title) {
		var redirectURL="dhcwlredirect.csp";
		var content = '<iframe scrolling="auto" frameborder="0" marginheight="0px" marginwidth="0px" seamless="seamless" src="'+redirectURL+'?url='+url+'" style="width:100%;height:100%;display:block;"></iframe>';
		$('#permisTabs').tabs('add',{
			title:title,
			content:content,
			closable:false
		});		
		
		/*
		if ($('#permisTabs').tabs('exists', title)){
			$('#permisTabs').tabs('select', title);
		}else{
			var content = '<iframe scrolling="auto" frameborder="0" marginheight="0px" marginwidth="0px" seamless="seamless" src="/dthealth/web/csp/dhcwlredirect.csp?url='+url+'" style="width:100%;height:100%;"></iframe>';
			$('#permisTabs').tabs('add',{
				title:title,
				content:content,
				closable:true
			});			
		}
		*/
		
	}	

	
	/*
	var tab = $('#permisTabs').tabs('getTab',1);  // get selected panel
	tab.panel('refresh');
	tab = $('#permisTabs').tabs('getTab',2);  // get selected panel
	tab.panel('refresh');
	tab = $('#permisTabs').tabs('getTab',3);  // get selected panel
	tab.panel('refresh');
	*/
	
	showRptGrpCfg();
	showGrpCfg();
	showGrpMemberCfg();
	
	var aryLoadedContent=[];
	aryLoadedContent['报表-组配置']={
		loadFlag:0
	};

	aryLoadedContent['组配置']={
		loadFlag:0
	};
	aryLoadedContent['组-人员配置']={
		loadFlag:0
	};

	aryLoadedContent['数据浏览']={
		loadFlag:1
	};
		
	$('#permisTabs').tabs({
		onSelect: function(title,index){
			if (index==0) return;
			if (aryLoadedContent[title].loadFlag==0) {
				var tab = $('#permisTabs').tabs('getTab',index);  // get selected panel
				tab.panel('refresh');
				aryLoadedContent[title].loadFlag=1;
			}
		}
	});	
	
	
	$('#permisTabs').tabs('select', "报表-组配置");
	
	
}

$(init);


var GetMapCfg=function() {
	var values=getFieldValues("formSerachConf");
	var cboRptType=values.cboRptType;
	var cboItems=$('#cboItems').combobox('getValues');
	var searchV=values.searchV;
	
	/*
	flag = $("#formSerachConf").form("validate");   //表单内容合法性检查
	if (!flag){
		myMsg("请按照提示填写信息");
		return;
	}
	*/	
	
	if (cboItems.length<2) {
		$.messager.alert("提示","显示内容不能少于2项。");
		return;	
	}
	var colObj={};
		
	colObj.rpt=[
			{field:'rptID',title:'ID',width:100,align:'left',hidden:true},
			{field:'rptName',title:'报表名称',width:100,align:'left'},
			{field:'rptCode',title:'报表编码',width:100,align:'left'}
		];
	colObj.grp=[
			{field:'grpID',title:'ID',width:100,align:'left',hidden:true},
			{field:'grpName',title:'组名称',width:100,align:'left'},
			{field:'grpCode',title:'组编码',width:100,align:'left'}
		
		];
	colObj.user=[
			{field:'userID',title:'人员ID',width:100,align:'left'},
			{field:'userName',title:'人员姓名',width:100,align:'left'}
		];		
			
	var col=[];
	//rpt,grp,user
	for(;cboItems.length>0;) {
		var items=cboItems.shift();
		col=col.concat(colObj[items]);
		delete colObj[items];
	}
	
	for (x in colObj) {
		var xCols=colObj[x];
		for (y in xCols) {
			var xC=xCols[y];
			$.extend(xC,{hidden:true});
		}
		col=col.concat(xCols);
	}
	
	
	cboItems=$('#cboItems').combobox('getValues');
	
	var browseDataGrid = $HUI.datagrid("#browseDataGrid",{
		columns:[col],
		url:$URL,
		queryParams: {
			ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
			QueryName:"GetMapCfg",		
			rptTool:cboRptType,
			mapItem:cboItems.join(","),
			searchV:searchV
		}		
	});
	/*
	var browseDataGrid = $HUI.datagrid("#browseDataGrid",{
		columns:[col]
	});	
	*/
		
}

var ClearSearch=function() {
	$("#cboRptType").combobox('setValues',"");
	$("#cboItems").combobox('setValues',"");
	$("#searchV").val("");
	
	
	var data=$("#cboItems").combobox('getData');
	for(i=0;i<data.length;i++){
		var rec=data[i];
		var objr =  document.getElementById("r"+rec.id);                                                                   
		$(objr).prop('checked',false);                                                                                     
	}
	
}