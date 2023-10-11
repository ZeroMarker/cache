var init=function(){
	var EXECUTABLE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.FunctionalElement&pClassMethod=GetExecutableTreeJson";
	var windowHight = document.documentElement.clientHeight;		//可获取到高度
 	var windowWidth = document.documentElement.clientWidth;

 	var ObjectReference=""  //选中的类别ID，全局变量
	var ObjectType=""		//选中的类别类型，全局变量

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
			ObjectType="G"
			ObjectReference=row.SSGRPRowId
			flag1=0;
			munuidname="";
	    	menuObjectType="";
	    	menurecord="";
	    	menustr="";
			//$('#itemtree').tree('reload')
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
			ObjectType="U"
			ObjectReference=row.SSUSRRowId
			flag1=0;
			munuidname="";
	    	menuObjectType="";
	    	menurecord="";
	    	menustr="";
			//$('#itemtree').tree('reload')
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
			ObjectType="L"
			ObjectReference=row.CTLOCRowID
			flag1=0;
			munuidname="";
	    	menuObjectType="";
	    	menurecord="";
	    	menustr="";
			//$('#itemtree').tree('reload')
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
    		/*if(flag1<1){
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
	    		//menustr=tkMakeServerCall('web.DHCBL.BDP.BDPAuthorize','GetMenuId',menuObjectType,menurecord[munuidname])
    			
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
			}*/
			return node.text
    	},
		onClick:function(node){
    		/*var idname="";
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
    		var record=$('#'+selectid+'grid').datagrid('getSelected');*/

    		if(ObjectReference==""){
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
    		/*for(var params in record){
    			if(params.indexOf('RowI')>=0){
    				idname=params;
    			}
    		}*/
    		/*var indexcspstr=tkMakeServerCall("web.DHCBL.BDP.BDPAuthorize","GetIndexcsp",node.id);
    		if (indexcspstr!="")
    		{
    			var indexcsp=indexcspstr.split("-")[0]
    			var base=indexcspstr.split("-")[1]
    			if((indexcsp!="")&&(indexcsp!="dhc.bdp.ext.default.csp")){
	    			var url="../csp/"+indexcsp+"?author=1&ObjectType="+ObjectType+"&ObjectReference="+record[idname]+"&authorMenuId="+node.id+base;
	    			$('#itemframe').attr('src',url)
	    		}
    		}*/
    		//console.log(ObjectType+"--load--"+node.id+"--"+record[idname])
    		$("#Editablegrid").datagrid("load",{
    			ClassName:"web.DHCBL.CT.FunctionalElement",
				MethodName:"GetItemJson",
				ObjectType:ObjectType,
				ObjectReference:ObjectReference,
				MenuID:	node.id			
    		})
    		$("#Diseditablegrid").datagrid("load",{
    			ClassName:"web.DHCBL.CT.FunctionalElement",
				MethodName:"GetItemJson",
				ObjectType:ObjectType,
				ObjectReference:ObjectReference,
				MenuID:	node.id,
				DisableFlag:1	
    		})
    		
    	}
	});

	//可编辑元素
	var Editablegrid=$HUI.datagrid('#Editablegrid',{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.CT.FunctionalElement",
			MethodName:"GetItemJson"					
		},
		columns:[[								
				{field:'ID',title:'ID',width:40,sortable:true,hidden:true},//,hidden:true
				{field:'Name',title:'描述',width:80},																
				]],	
		height: windowHight-120,
		width:	(windowWidth-250-250-36)*0.5,		
		idField:'ID',
		loadMsg:'',
        showRefresh:false,
		singleSelect:false, //只允许选中一行
		remoteSort:false,    
		rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动 
		toolbar:"#ableitembar",
        onClickRow:function(index,row){
        	
        },
        onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                
                return false;
            }
            return true;
        }

	});

	var Diseditablegrid=$HUI.datagrid('#Diseditablegrid',{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.CT.FunctionalElement",
			MethodName:"GetItemJson"					
		},
		columns:[[								
				{field:'ID',title:'ID',width:40,sortable:true,hidden:true},//,hidden:true
				{field:'Name',title:'描述',width:80},																
				]],				
		height: windowHight-120,
		width:	(windowWidth-250-250-36)*0.5,
		singleSelect:false,
		idField:'ID',
		loadMsg:'',
        showRefresh:false,
		singleSelect:false, //只允许选中一行
		remoteSort:false,    
		rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动 
        toolbar:"#disableitembar",
         onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                
                return false;
            }
            return true;
        }
	});
	//查找可编辑元素
	$('#AbleItemDesc').searchbox({
		searcher:function(value,name){
			SearchAbleItem(value);
		}
	});
	//重置搜索可编辑元素
	$("#btnAbleItemRefresh").click(function (e) { 
		$('#AbleItemDesc').searchbox('setValue','');
		SearchAbleItem("");
		var desc=$('#DisableItemDesc').searchbox("getValue")
		SearchDisableItem(desc);
	 })

	//查找可编辑元素
	SearchAbleItem=function(value){
		var nodeid=$("#itemtree").tree('getSelected').id
		

		$("#Editablegrid").datagrid("load",{
			ClassName:"web.DHCBL.CT.FunctionalElement",
			MethodName:"GetItemJson",
			ObjectType:ObjectType,
			ObjectReference:ObjectReference,
			MenuID:	nodeid,
			Desc:value	
		})

	}


	//查找不可编辑元素
	$('#DisableItemDesc').searchbox({
		searcher:function(value,name){
			SearchDisableItem(value);
		}
	});
	//重置搜索不可编辑元素
	$("#btnDisbleItemRefresh").click(function (e) { 
		$('#DisableItemDesc').searchbox('setValue','');
		SearchDisableItem("");
		var desc=$('#AbleItemDesc').searchbox("getValue")
		SearchAbleItem(desc);
	 })
	//查找不可编辑元素
	SearchDisableItem=function(value){

		var nodeid=$("#itemtree").tree('getSelected').id

		$("#Diseditablegrid").datagrid("load",{
			ClassName:"web.DHCBL.CT.FunctionalElement",
			MethodName:"GetItemJson",
			ObjectType:ObjectType,
			ObjectReference:ObjectReference,
			MenuID:	nodeid,
			DisableFlag:1,
			Desc:value		
		})
	}

	//添加一项
	$("#addOne").click(function (e) { 
		AddFunlib("Editablegrid","Diseditablegrid");
	 })
	//添加全部
	$("#addAll").click(function (e) { 
		$("#Editablegrid").datagrid("selectAll")
		AddFunlib("Editablegrid","Diseditablegrid");
	 })
	//删除一项
	$("#delOne").click(function (e) { 
		AddFunlib("Diseditablegrid","Editablegrid");
	 })
	//删除全部
	$("#delAll").click(function (e) {
		$("#Diseditablegrid").datagrid("selectAll")
		AddFunlib("Diseditablegrid","Editablegrid");
	 })
	//清空不可编辑元素
	$("#btnRefreshItem").click(function (e) {
		$("#Diseditablegrid").datagrid("selectAll")
		AddFunlib("Diseditablegrid","Editablegrid");
	 })

	//保存权限配置
	$("#btnSaveEnableItem").click(function (e) {
		var records=$("#Diseditablegrid").datagrid("getRows")
		var Data="" 
		if (records)
		{
			for (var m=0;m<records.length;m++)
			{
				var record=records[m]
				if (record=="")
				{
					break
				}
				else
				{
					//[{ID:116||2156},{ID:116||2157}]
					if (Data=="")
					{
						Data="{ID:"+record.ID+"}"
					}
					else
					{
						Data=Data+",{ID:"+record.ID+"}"
					}
				}
			}
			
			//{ID:216||3},{ID:216||4},{ID:216||5},{ID:216||6},{ID:216||7},{ID:216||8}]
		}
		Data="["+Data+"]"
		var SubKey=$("#itemtree").tree('getSelected').id		//菜单的id
		//web.DHCBL.Authorize.Executables SaveAuthorizeData
		var result = tkMakeServerCall("web.DHCBL.Authorize.Executables", "SaveAuthorizeData", ObjectType,ObjectReference,Data,SubKey);
		result=eval('('+result+')')

		if (result.msg==0)
		{
			$.messager.popover({
                    msg: '保存成功！',
                    type: 'success',
                    timeout: 1000
                });
		}
		else
		{
			$.messager.popover({
                    msg: '保存失败！'+result.msg,
                    type: 'error',
                    timeout: 2000
                });
		}
	 })

	//数据移动
	AddFunlib=function(from,to) {		
		var className = document.getElementById("addAll").class;
		var datas = $('#'+from).datagrid('getSelections');	 //获取所有选中的行
		var length=datas.length
		if(datas==""){
			$.messager.alert('提示',"未选中要添加的行!","info");						
			return false;
		}
		if(datas.length>0)
		{	
			var arry=[]		
			for(var i=0;i<length;i++)
			{					
				var RowID=datas[i].ID
				var Desc=datas[i].Name
				var rows = $("#"+to).datagrid("getRows"); //获取当前页的所有行。
				var flag=0;
				for(var j=0;j<rows.length;j++)			//判断重复
				{
					if(RowID==rows[j].ID){
						flag=1;
						break;
					}	
				}
				if(flag==0)	//不重复
				{
					arry[i]=RowID
					$('#'+to).datagrid('appendRow',{			
						ID: RowID,
						Name:Desc
					})	
				}							
			}
			
			for(var j=0;j<arry.length;j++)
			{
				var index=$('#'+from).datagrid("getRowIndex",arry[j])
				if (index!=-1)
				{
					$('#'+from).datagrid("deleteRow",index)
					
				}	
			}
						
		}
		$('#'+from).datagrid("unselectAll")	
		$('#'+to).datagrid("unselectAll")		
	}



}
$(init)