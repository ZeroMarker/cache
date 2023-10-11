/*
* @Author: 基础数据平台-谢海睿
* @Date:   2019-10-12 10:36:35
* @Last Modified by:   admin
* @Last Modified time: 2019-10-15 14:55:56
* @描述:医生站——知识库授权
*/
var init=function(){
	var ObjectReference=""  //选中的类别ID，全局变量
	var ObjectType=""		//选中的类别类型，全局变量
	var GetGroupList_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.Authorize.BDPAuthorize&pClassQuery=GetGroupList";  //获取安全组数据
	var GetLocList_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.Authorize.BDPAuthorize&pClassQuery=GetLocList";  //获取科室数据
	var GetUserList_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.Authorize.BDPAuthorize&pClassQuery=GetUserList";  //获取用户数据
	//遮罩层
	$.extend($.fn,{
		mask: function(msg,maskDivClass){
		this.unmask();
		// 参数
		var op = {
			opacity: 0.8,
			z: 10000,
			bgcolor: '#ffffff'
		};
		var original=$(document.body);
		var position={top:0,left:0};
				if(this[0] && this[0]!==window.document){
				original=this;
				position=original.position();
				}
		// 创建一个 Mask 层，追加到对象中
		var maskDiv=$('<div class="maskdivgen"> </div>');
		maskDiv.appendTo(original);
		var maskWidth=original.outerWidth();
		if(!maskWidth){
			maskWidth=original.width();
		}
		var maskHeight=original.outerHeight();
		if(!maskHeight){
			maskHeight=original.height();
		}
		maskDiv.css({
			position: 'absolute',
			top: position.top,
			left: position.left,
			'z-index': op.z,
			width: maskWidth,
			height:maskHeight,
			'background-color': '#E6E6E6',
			opacity: 0
		});
		if(maskDivClass){
			maskDiv.addClass(maskDivClass);
		}
		if(msg){
			var msgDiv=$('<div style="position:absolute;border:#6593cf 1px solid; padding:2px;background:#ccca"><div style="line-height:24px;border:#a3bad9 1px solid;background:white;padding:2px 10px 2px 10px">'+msg+'</div></div>');
			msgDiv.appendTo(maskDiv);
			var widthspace=(maskDiv.width()-msgDiv.width());
			var heightspace=(maskDiv.height()-msgDiv.height());
			msgDiv.css({
				cursor:'wait',
				top:(heightspace/2-2),
				left:(widthspace/2-2)
			});
		}
		maskDiv.fadeIn('fast', function(){
			// 淡入淡出效果
			$(this).fadeTo('slow', op.opacity);
		})
		return maskDiv;
		},
	unmask: function(){
			var original=$(document.body);
			if(this[0] && this[0]!==window.document){
				original=$(this[0]);
			}
			original.find("> div.maskdivgen").fadeOut('slow',0,function(){
			$(this).remove();
			});
		}
	});

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
		singleSelect:true,
		idField:'SSGRPRowId',
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onSelect:function(index, row){
			var record=$('#groupgrid').datagrid('getSelected');     	   		
			var ObjectReference=record.SSGRPRowId;	
			var ObjectType='G';
			var knowledge="knowledge";
			var Baike="Baike";
			var diagnose="diagnose";
			var OpenSurgery="OpenSurgery";
			var knowledge=tkMakeServerCall("web.DHCBL.MKB.MKBPreferences","OpenData",ObjectType,ObjectReference,knowledge);
			var Baike=tkMakeServerCall("web.DHCBL.MKB.MKBPreferences","OpenData",ObjectType,ObjectReference,Baike);
			var diagnose=tkMakeServerCall("web.DHCBL.MKB.MKBPreferences","OpenData",ObjectType,ObjectReference,diagnose);
			var OpenSurgery=tkMakeServerCall("web.DHCBL.MKB.MKBPreferences","OpenData",ObjectType,ObjectReference,OpenSurgery);
			$('#itemdiv').unmask();//去掉遮罩
			if(knowledge=="Y"){
				$("#knowledge").checkbox('setValue',true);
			}else{
				$("#knowledge").checkbox('setValue',false);
			}
			if(Baike=="Y"){
				$("#Baike").checkbox('setValue',true);
			}else{
				$("#Baike").checkbox('setValue',false);
			}
			if(diagnose=="Y"){
				$("#diagnose").checkbox('setValue',true);
			}else{
				$("#diagnose").checkbox('setValue',false);
			}
			if(OpenSurgery=="Y"){
				$("#OpenSurgery").checkbox('setValue',true);
			}else{
				$("#OpenSurgery").checkbox('setValue',false);
			}
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
		onSelect:function(index, row){
			var record=$('#usergrid').datagrid('getSelected');     	   		 
			var ObjectReference=record.SSUSRRowId;	
			var ObjectType='U';
			var knowledge="knowledge";
			var Baike="Baike";
			var diagnose="diagnose";
			var OpenSurgery="OpenSurgery";
			var knowledge=tkMakeServerCall("web.DHCBL.MKB.MKBPreferences","OpenData",ObjectType,ObjectReference,knowledge);
			var Baike=tkMakeServerCall("web.DHCBL.MKB.MKBPreferences","OpenData",ObjectType,ObjectReference,Baike);
			var diagnose=tkMakeServerCall("web.DHCBL.MKB.MKBPreferences","OpenData",ObjectType,ObjectReference,diagnose);
			var OpenSurgery=tkMakeServerCall("web.DHCBL.MKB.MKBPreferences","OpenData",ObjectType,ObjectReference,OpenSurgery);
			$('#itemdiv').unmask();//去掉遮罩
			if(knowledge=="Y"){
				$("#knowledge").checkbox('setValue',true);
			}else{
				$("#knowledge").checkbox('setValue',false);
			}
			if(Baike=="Y"){
				$("#Baike").checkbox('setValue',true);
			}else{
				$("#Baike").checkbox('setValue',false);
			}
			if(diagnose=="Y"){
				$("#diagnose").checkbox('setValue',true);
			}else{
				$("#diagnose").checkbox('setValue',false);
			}
			if(OpenSurgery=="Y"){
				$("#OpenSurgery").checkbox('setValue',true);
			}else{
				$("#OpenSurgery").checkbox('setValue',false);
			}
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
		singleSelect:true,
		idField:'CTLOCRowID',
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		onSelect:function(index, row){
			var record=$('#locgrid').datagrid('getSelected');     	   		
			var ObjectReference=record.CTLOCRowID;	
			var ObjectType='L';
			var knowledge="knowledge";
			var Baike="Baike";
			var diagnose="diagnose";
			var OpenSurgery="OpenSurgery";
			var knowledge=tkMakeServerCall("web.DHCBL.MKB.MKBPreferences","OpenData",ObjectType,ObjectReference,knowledge);
			var Baike=tkMakeServerCall("web.DHCBL.MKB.MKBPreferences","OpenData",ObjectType,ObjectReference,Baike);
			var diagnose=tkMakeServerCall("web.DHCBL.MKB.MKBPreferences","OpenData",ObjectType,ObjectReference,diagnose);
			var OpenSurgery=tkMakeServerCall("web.DHCBL.MKB.MKBPreferences","OpenData",ObjectType,ObjectReference,OpenSurgery);
			$('#itemdiv').unmask();//去掉遮罩
			if(knowledge=="Y"){
				$("#knowledge").checkbox('setValue',true);
			}else{
				$("#knowledge").checkbox('setValue',false);
			}
			if(Baike=="Y"){
				$("#Baike").checkbox('setValue',true);
			}else{
				$("#Baike").checkbox('setValue',false);
			}
			if(diagnose=="Y"){
				$("#diagnose").checkbox('setValue',true);
			}else{
				$("#diagnose").checkbox('setValue',false);
			}
			if(OpenSurgery=="Y"){
				$("#OpenSurgery").checkbox('setValue',true);
			}else{
				$("#OpenSurgery").checkbox('setValue',false);
			}
		}
	});	
	//搜索
	$('#tab_div').tabs({
		onSelect:function(title,index){
			if(index === 2){
				$('#locgrid').datagrid('resize')
			}else if(index ===3){
				$('#usergrid').datagrid('resize')
			}
		}
	})
	$('#textgroup').searchbox({
		searcher:function(value,name){
			var desc=$.trim($("#textgroup").searchbox('getValue'));
			$('#groupgrid').datagrid('load',  { 
				'ClassName':"web.DHCBL.Authorize.BDPAuthorize",
				'QueryName':"GetGroupList",
				'desc': desc
			});
			$('#groupgrid').datagrid('unselectAll');
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
			$('#locgrid').datagrid('unselectAll');
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
			$('#usergrid').datagrid('unselectAll');
		}
	});	
	//重置
	$("#btnGroupRefresh").click(function (e) { 
		$("#textgroup").searchbox('setValue', '');
		$('#groupgrid').datagrid('load',  { 
			'ClassName':"web.DHCBL.Authorize.BDPAuthorize",
			'QueryName':"GetGroupList",
			'desc': ''
		});
		$('#groupgrid').datagrid('unselectAll');
		
		$("#knowledge").checkbox('setValue',false);
		$("#Baike").checkbox('setValue',false);
		$("#diagnose").checkbox('setValue',false);
		$("#OpenSurgery").checkbox('setValue',false);
	
		$('#itemdiv').mask();//给基础数据授权页面加遮罩
	 })  
	$("#btnLocRefresh").click(function (e) { 
		$("#textloc").searchbox('setValue', '');
		$('#locgrid').datagrid('load',  { 
			'ClassName':"web.DHCBL.Authorize.BDPAuthorize",
			'QueryName':"GetLocList",
			'desc': ''
		});
		$('#locgrid').datagrid('unselectAll');
		
		$("#knowledge").checkbox('setValue',false);
		$("#Baike").checkbox('setValue',false);
		$("#diagnose").checkbox('setValue',false);
		$("#OpenSurgery").checkbox('setValue',false);
		
		$('#itemdiv').mask();//给基础数据授权页面加遮罩
	 })  
	$("#btnUserRefresh").click(function (e) { 
		$("#textuser").searchbox('setValue', '');
		$('#usergrid').datagrid('load',  {
			'ClassName':"web.DHCBL.Authorize.BDPAuthorize",
			'QueryName':"GetUserList",
			'desc': ''
		});
		$('#usergrid').datagrid('unselectAll');
		
		$("#knowledge").checkbox('setValue',false);
		$("#Baike").checkbox('setValue',false);
		$("#diagnose").checkbox('setValue',false);
		$("#OpenSurgery").checkbox('setValue',false);
		
		$('#itemdiv').mask();//给基础数据授权页面加遮罩
	 }) 
	 //在没有选择页面的时候给是否允许开例诊断加遮罩
	if(ObjectReference==""||ObjectType==""){
		$('#itemdiv').mask();//给基础数据授权页面加遮罩
	}
	//是否允许开例诊断
	$HUI.checkbox('#diagnose',{
		onChecked:function(e,value){
			var selectid=$('#tab_div').tabs('getSelected')[0].id;
			var record=$('#'+selectid+'grid').datagrid('getSelected');     	   		
			switch(selectid){
				case 'group':ObjectType='G'
				ObjectReference=record.SSGRPRowId				
				break;
				case 'loc':ObjectType='L'
				ObjectReference=record.CTLOCRowID 
				break;    			
				case 'user':ObjectType='U'
				ObjectReference=record.SSUSRRowId			
				break;
			}
			var MKBValue = "Y";
			var ValueType="diagnose";
			//保存改动后的数据
			var rtn = tkMakeServerCall("web.DHCBL.MKB.MKBPreferences","SaveEntity",ObjectType,ObjectReference,ValueType,MKBValue);	
		},
		onUnchecked:function(e,value){
			var selectid=$('#tab_div').tabs('getSelected')[0].id;
			var record=$('#'+selectid+'grid').datagrid('getSelected');     	   		
			switch(selectid){
				case 'group':ObjectType='G'
				ObjectReference=record.SSGRPRowId				
				break;
				case 'loc':ObjectType='L'
				ObjectReference=record.CTLOCRowID 
				break;    			
				case 'user':ObjectType='U'
				ObjectReference=record.SSUSRRowId			
				break;
			}
			var MKBValue= "N";
			var ValueType="diagnose";
			//保存改动后的数据
			var rtn = tkMakeServerCall("web.DHCBL.MKB.MKBPreferences","SaveEntity",ObjectType,ObjectReference,ValueType,MKBValue);	
		}
	});
	//是否允许使用医为百科
	$HUI.checkbox('#Baike',{
		onChecked:function(e,value){
			var selectid=$('#tab_div').tabs('getSelected')[0].id;
			var record=$('#'+selectid+'grid').datagrid('getSelected');     	   		
			switch(selectid){
				case 'group':ObjectType='G'
				ObjectReference=record.SSGRPRowId				
				break;
				case 'loc':ObjectType='L'
				ObjectReference=record.CTLOCRowID 
				break;    			
				case 'user':ObjectType='U'
				ObjectReference=record.SSUSRRowId			
				break;
			}
			var MKBValue = "Y";
			var ValueType="Baike";
			//保存改动后的数据
			var rtn = tkMakeServerCall("web.DHCBL.MKB.MKBPreferences","SaveEntity",ObjectType,ObjectReference,ValueType,MKBValue);	
		},
		onUnchecked:function(e,value){
			var selectid=$('#tab_div').tabs('getSelected')[0].id;
			var record=$('#'+selectid+'grid').datagrid('getSelected');     	   		
			switch(selectid){
				case 'group':ObjectType='G'
				ObjectReference=record.SSGRPRowId				
				break;
				case 'loc':ObjectType='L'
				ObjectReference=record.CTLOCRowID 
				break;    			
				case 'user':ObjectType='U'
				ObjectReference=record.SSUSRRowId			
				break;
			}
			var MKBValue = "N";
			var ValueType="Baike";
			//保存改动后的数据
			var rtn = tkMakeServerCall("web.DHCBL.MKB.MKBPreferences","SaveEntity",ObjectType,ObjectReference,ValueType,MKBValue);	
		}
	});
	//是否允许开例诊断
	$HUI.checkbox('#knowledge',{
		onChecked:function(e,value){
			var selectid=$('#tab_div').tabs('getSelected')[0].id;
			var record=$('#'+selectid+'grid').datagrid('getSelected');     	   		
			switch(selectid){
				case 'group':ObjectType='G'
				ObjectReference=record.SSGRPRowId				
				break;
				case 'loc':ObjectType='L'
				ObjectReference=record.CTLOCRowID 
				break;    			
				case 'user':ObjectType='U'
				ObjectReference=record.SSUSRRowId			
				break;
			}
			var MKBValue = "Y";
			var ValueType="knowledge";
			//保存改动后的数据
			var rtn = tkMakeServerCall("web.DHCBL.MKB.MKBPreferences","SaveEntity",ObjectType,ObjectReference,ValueType,MKBValue);	
		},
		onUnchecked:function(e,value){
			var selectid=$('#tab_div').tabs('getSelected')[0].id;
			var record=$('#'+selectid+'grid').datagrid('getSelected');     	   		
			switch(selectid){
				case 'group':ObjectType='G'
				ObjectReference=record.SSGRPRowId				
				break;
				case 'loc':ObjectType='L'
				ObjectReference=record.CTLOCRowID 
				break;    			
				case 'user':ObjectType='U'
				ObjectReference=record.SSUSRRowId			
				break;
			}
			var MKBValue = "N";
			var ValueType="knowledge";
			//保存改动后的数据
			var rtn = tkMakeServerCall("web.DHCBL.MKB.MKBPreferences","SaveEntity",ObjectType,ObjectReference,ValueType,MKBValue);	
		}
	});
	//是否允许开立手术
	$HUI.checkbox('#OpenSurgery',{
		onChecked:function(e,value){
			var selectid=$('#tab_div').tabs('getSelected')[0].id;
			var record=$('#'+selectid+'grid').datagrid('getSelected');     	   		
			switch(selectid){
				case 'group':ObjectType='G'
				ObjectReference=record.SSGRPRowId				
				break;
				case 'loc':ObjectType='L'
				ObjectReference=record.CTLOCRowID 
				break;    			
				case 'user':ObjectType='U'
				ObjectReference=record.SSUSRRowId			
				break;
			}
			var MKBValue = "Y";
			var ValueType="OpenSurgery";
			//保存改动后的数据
			var rtn = tkMakeServerCall("web.DHCBL.MKB.MKBPreferences","SaveEntity",ObjectType,ObjectReference,ValueType,MKBValue);	
		},
		onUnchecked:function(e,value){
			var selectid=$('#tab_div').tabs('getSelected')[0].id;
			var record=$('#'+selectid+'grid').datagrid('getSelected');     	   		
			switch(selectid){
				case 'group':ObjectType='G'
				ObjectReference=record.SSGRPRowId				
				break;
				case 'loc':ObjectType='L'
				ObjectReference=record.CTLOCRowID 
				break;    			
				case 'user':ObjectType='U'
				ObjectReference=record.SSUSRRowId			
				break;
			}
			var MKBValue = "N";
			var ValueType="OpenSurgery";
			//保存改动后的数据
			var rtn = tkMakeServerCall("web.DHCBL.MKB.MKBPreferences","SaveEntity",ObjectType,ObjectReference,ValueType,MKBValue);	
		}
	});
}
$(init)