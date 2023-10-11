var init=function(){
	var EXECUTABLE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPAuthorize&pClassMethod=GetExecutableTreeJsonNew";

	var groupgrid=$HUI.datagrid('#groupgrid',{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.Authorize.BDPAuthorize",
			QueryName:"GetGroupList"
		},
		columns:[[
				{field:'SSGRPRowId',title:'安全组ID',width:80,sortable:true,hidden:true},
				{field:'SSGRPDesc',title:'安全组名',width:80,sortable:true}
				]],
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:20,
		toolbar:'#groupbar',
		//pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		singleSelect:true,
		idField:'SSGRPRowId',
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		onClickRow:function(index,row){
			flag1=0;
			munuidname="";
	    	menuObjectType="";
	    	menurecord="";
	    	menustr="";
			$('#itemtree').tree('reload')
		}		
	});	
	var usergrid=$HUI.datagrid('#usergrid',{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.Authorize.BDPAuthorize",
			QueryName:"GetUserList"
		},
		columns:[[
				{field:'SSUSRRowId',title:'用户ID',width:80,sortable:true,hidden:true},
				{field:'SSUSRName',title:'用户',width:80,sortable:true}
				]],
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:20,
		toolbar:'#userbar',
		//pageList:[5,10,13,15,20,25,30,50,75,100,200,300,500,1000],
		singleSelect:true,
		idField:'SSUSRRowId',
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		onClickRow:function(index,row){
			flag1=0;
			munuidname="";
	    	menuObjectType="";
	    	menurecord="";
	    	menustr="";
			$('#itemtree').tree('reload')
		}		
	});
	var locgrid=$HUI.datagrid('#locgrid',{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.Authorize.BDPAuthorize",
			QueryName:"GetLocList"
		},
		columns:[[
				{field:'CTLOCRowID',title:'科室ID',width:80,sortable:true,hidden:true},
				{field:'CTLOCDesc',title:'科室名',width:80,sortable:true}
				]],
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:20,
		toolbar:'#locbar',
		//pageList:[5,10,13,15,20,25,30,50,75,100,200,300,500,1000],
		singleSelect:true,
		idField:'CTLOCRowID',
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		onClickRow:function(index,row){
			flag1=0;
			munuidname="";
	    	menuObjectType="";
	    	menurecord="";
	    	menustr="";
			$('#itemtree').tree('reload')
		}		
	});	
	$('#textgroup').searchbox({
		searcher:function(value,name){
			var desc=$.trim($("#textgroup").searchbox('getValue'));
			$('#groupgrid').datagrid('load',  { 
				'ClassName':"web.DHCBL.Authorize.BDPAuthorize",
				'QueryName':"GetGroupList",
				'desc': desc
			});
		}
	});
	$('#textloc').searchbox({
		searcher:function(value,name){
			var desc=$.trim($("#textloc").searchbox('getValue'));
			$('#locgrid').datagrid('load',  { 
				'ClassName':"web.DHCBL.Authorize.BDPAuthorize",
				'QueryName':"GetLocList",
				'desc': desc
			});
		}
	});
	$('#textuser').searchbox({
		searcher:function(value,name){
			var desc=$.trim($("#textuser").searchbox('getValue'));
			$('#usergrid').datagrid('load',  { 
				'ClassName':"web.DHCBL.Authorize.BDPAuthorize",
				'QueryName':"GetUserList",
				'desc': desc
			});
		}
	});	
	$("#btnGroupRefresh").click(function (e) { 
		$("#textgroup").searchbox('setValue', '');
		$('#groupgrid').datagrid('load',  { 
			'ClassName':"web.DHCBL.Authorize.BDPAuthorize",
			'QueryName':"GetGroupList",
			'desc': ''
		});
	 })  
	$("#btnLocRefresh").click(function (e) { 
		$("#textloc").searchbox('setValue', '');
		$('#locgrid').datagrid('load',  { 
			'ClassName':"web.DHCBL.Authorize.BDPAuthorize",
			'QueryName':"GetLocList",
			'desc': ''
		});
	 })  
	$("#btnUserRefresh").click(function (e) { 
		$("#textuser").searchbox('setValue', '');
		$('#usergrid').datagrid('load',  {
			'ClassName':"web.DHCBL.Authorize.BDPAuthorize",
			'QueryName':"GetUserList",
			'desc': ''
		});
	 })  
	var flag1=0;
	var munuidname="";
    var menuObjectType="";
    var menurecord="";
    var menustr="";
    
	var itemtree=$('#itemtree').tree({
    	url:EXECUTABLE_ACTION_URL,
    	animate:true,
    	lines:true,
    	formatter:function(node){
    		if(flag1<1){
    			var selectid=$('#accordionpanel').accordion('getSelected')[0].id;
	    		switch(selectid){
	    			case 'group':menuObjectType='G'
	    			break;
	    			case 'loc':menuObjectType='L'
	    			break;
	    			case 'user':menuObjectType='U'
	    			break;
	    		}
	    		menurecord=$('#'+selectid+'grid').datagrid('getSelected');
	    		if(menurecord==null){
	    			return node.text
	    		}
	    		for(var params in menurecord){
	    			if(params.indexOf('RowI')>=0){
	    				munuidname=params;
	    			}
	    		}
	    		menustr=tkMakeServerCall('web.DHCBL.BDP.BDPAuthorize','GetMenuId',menuObjectType,menurecord[munuidname])
    			
    		}
    		flag1++;
    		var menuarr=menustr.split('^')
			for(var i=0;i<=menuarr.length-1;i++){
				if(menuarr[i]==(' '+node.id)){
					return '<font color="red">'+node.text+'</font>'
				}
				else{
					return node.text
				}
			}
    	},
		onClick:function(node){
    		var idname="";
    		var ObjectType=""
    		var selectid=$('#accordionpanel').accordion('getSelected')[0].id;
    		switch(selectid){
    			case 'group':ObjectType='G'
    			break;
    			case 'loc':ObjectType='L'
    			break;
    			case 'user':ObjectType='U'
    			break;
    		}
    		var record=$('#'+selectid+'grid').datagrid('getSelected');
    		if(!record){
    			$.messager.show({
                    title:'提示信息',
                    msg:'授权类别未选择！',
                    showType:'show',
                    timeout:3000,
                    style:{
                      right:'',
                      bottom:''
                    }
                });
                return
    		}
    		for(var params in record){
    			if(params.indexOf('RowI')>=0){
    				idname=params;
    			}
    		}
    		var indexcsp=tkMakeServerCall("web.DHCBL.BDP.BDPAuthorize","GetIndexcsp",node.id);
    		if((indexcsp!="")&&(indexcsp!="dhc.bdp.ext.default.csp")){
    			var url="../csp/"+indexcsp+"?author=1&ObjectType="+ObjectType+"&ObjectReference="+record[idname]+"&authorMenuId="+node.id;
    			$('#itemframe').attr('src',url)
    		}
    	}
	});

}
$(init)