/// 名称: 医用知识库 -引用属性格式的属性内容维护
/// 描述: 包含增删改上移下移等功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2018-04-03

var init = function(){

	var HISUI_SQLTableName="MKB_TermProDetail"+property,HISUI_ClassTableName="User.MKBTermProDetail"+property;
	
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=DeleteData";
	var DELETE_ALL_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=DeleteAllSelTerm";
	var SAVE_CHECK_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=SaveSelectTermIds";
	
     //添加右键股则管理菜单
	var termBaseAndId=tkMakeServerCall('web.DHCBL.MKB.MKBTermProDetail','GetBaseByProperty',property);
	var termBaseAndIdArr=termBaseAndId.split("^")
	var termBase=termBaseAndIdArr[0]
	var termRowId=termBaseAndIdArr[1]
	var ProConfig=termBaseAndIdArr[2]
	var rightMenuInfos=tkMakeServerCall('web.DHCBL.MKB.MKBKLMappingDetail','CreateRightMenu',termBase);
	var menuStr=""
	if (rightMenuInfos!="")
	{
		var rightMenuInfo=rightMenuInfos.split("[A]")		
		for (var i = 0; i <rightMenuInfo.length; i++) {
			var rightMenu =rightMenuInfo[i];  //右键菜单
			var rightMenu=eval('(' + rightMenu + ')');
			menuStr=menuStr+'<div id='+rightMenu.MKBKMBRowId+' name="规则管理" iconCls="icon-set-paper" data-options="">'+rightMenu.MKBKMBDesc+'</div>'			
		}
	}
	
	//datagrid列
	var columns =[[  
					{field:'opt',title:'操作',width:50,align:'center',  
						formatter:function(value,row,index){  
							var btn = '<a class="editcls" onclick="DelData('+row.MKBTPDRowId+')" href="#">删除</a>';  
							return btn;  
						}  
					} ,  
					{field:'MKBTPDRowId',title:'属性内容表id',width:80,sortable:true,hidden:true},
					{field:'MKBTPDSequence',title:'顺序',width:150,sortable:true,hidden:true,
						sorter:function (a,b){  
							if(a.length > b.length) return 1;
								else if(a.length < b.length) return -1;
								else if(a > b) return 1;
								else return -1;
						}
					},
					{field:'MKBTRowId',title:'RowId',width:80,sortable:true,hidden:true},
					{field:'MKBTDesc',title:'描述',width:150,sortable:true},
					{field:'MKBTCode',title:'代码',width:150,sortable:true}
				]];
				
	//列表datagrid
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.MKB.MKBTermProDetail",
			QueryName:"GetSellistTermList",
			property:property
		},
		columns:columns,
		pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏
		singleSelect:true,
		idField:'MKBTRowId', 
		toolbar:'#mytbar',
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		sortName : 'MKBTPDSequence',
		sortOrder : 'asc', 
		onLoadSuccess:function(data){
			//$(".pagination-page-list").hide();
			//设置删除按钮图标
			$('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'});
			if($('#myWin').is(":visible"))  //如果新增术语窗口打开了，则刷新未选列表
			{
				TermSearch();
			}
			
			if (detailId!="")
        	{
        		var index=$(this).datagrid('getRowIndex',detailId);
        		$(this).datagrid('selectRow',index);
        		$(this).prev().find('div.datagrid-body').prop('scrollTop',index);
        	}
		},
		onDblClickRow:function(rowIndex,rowData){
			changeUpDownStatus(rowIndex);
		},
		onClickRow:function(rowIndex,rowData){
			changeUpDownStatus(rowIndex);
		
		},
		onRowContextMenu: function(e, rowIndex, rowData){   //右键菜单
			var $clicked=$(e.target);
			e.preventDefault();  //阻止浏览器捕获右键事件
			$(this).datagrid("selectRow", rowIndex); //根据索引选中该行 
			
			//添加右键股则管理菜单和文献预览菜单
            var docMenuStr=""
            var detailIdStr=termRowId+"-"+property+":S"+rowData.MKBTRowId
			var docMenuInfos=tkMakeServerCall('web.DHCBL.MKB.MKBKLMappingDetail','CreateDocRightMenu',termBase,detailIdStr);
			if (docMenuInfos!="")
			{
				var docMenuInfo=docMenuInfos.split("[A]")
				for (var i = 0; i <docMenuInfo.length; i++) {
					var docMenu =docMenuInfo[i];  //右键菜单
					var docMenu=eval('(' + docMenu + ')');
					//alert(docMenu)
					docMenuStr=docMenuStr+'<div id='+docMenu.DocPath+' name="文献预览" iconCls="icon-paper-info">'+docMenu.DocDesc+'</div>'			
				}
				docMenuStr='<div iconCls="icon-paper-link"><span>文献预览</span><div style="width:500px;">'+docMenuStr+'</div></div>'
			}
						
            var mygridmm = $('<div style="width:160px;"></div>').appendTo('body');
            //$( menuStr+docMenuStr).appendTo(mygridmm).click(stopPropagation); //右键菜单里 在IE8下点击右键菜单的按钮 ，没有执行点击事件，原因：append的onclick不会触发，用html的可以触发。
            mygridmm.html('<div onclick="SeeVersion()" iconCls="icon-apply-check" data-options="">查看版本</div>' +
	       			'<div onclick="SeeChangeLog()" iconCls="icon-apply-check" data-options="">查看日志</div>'+
	       			menuStr+docMenuStr).click(stopPropagation);
            //mygridmm.menu()
           mygridmm.menu({
			    onClick:function(item){
			    	var itemid=item.id
					if ((item.name=="规则管理")&(itemid!="")&(itemid!=null)&(itemid!=undefined)){	
						var detailIdStr=termRowId+"-"+property+":S"+rowData.MKBTRowId
						var newOpenUrl="../csp/dhc.bdp.mkb.mkbklmappingdetail.csp?mappingBase="+itemid+"&termBase="+termBase+"&detailIdStr="+detailIdStr
						CheckMappingDetail(newOpenUrl)
						//window.open(newOpenUrl, 'newwindow', 'height=600, width=1000, top=120, left=260, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no')				
					}
					if ((item.name=="文献预览")&(itemid!="")&(itemid!=null)&(itemid!=undefined)){	
						previewFile(itemid)
					}
			    }
			});
			mygridmm.menu('show',{
                left:e.pageX,
                top:e.pageY
            });
        }
			  
	});	

	
	//重置按钮
	$("#btnRefresh").click(function (e) { 
		ClearFunLib();
	 }) 
 
	//删除按钮
	$("#del_btn").click(function (e) { 
		DelAllData();
	}) 
	
	//已选术语上移按钮
	$("#btnUp").click(function (e) { 
		OrderFunLib("up");
	}) 	 
	
	//已选术语下移按钮
	$("#btnDown").click(function (e) { 
		OrderFunLib("down");
	}) 
	
	//新增术语按钮
	$("#btnAddTerm").click(function (e) { 
		TopListWin();
	}) 
	  	
	//*********新增术语弹框的按钮**************/
	//术语搜索按钮
	/*$('#TextDesc').searchbox({
		searcher:function(value,name){
			TermSearch();
		}
	});
	
	//检索框单击选中输入内容
	$('#TextDesc').searchbox('textbox').bind('click',function(){
		$('#TextDesc').searchbox('textbox').select()         
	 });*/
	
	//术语搜索按钮
	 $("#TextDesc").keyup(function(){
     	TermSearch();
    });
    //检索框单击选中输入内容
	$('#TextDesc').bind('click',function(){
		$('#TextDesc').select()         
	 });	
	 
	//术语重置按钮
	$("#btnTermReset").click(function (e) { 
		TermReset();
	}) 	
	//术语保存按钮
	$("#btnTermSave").click(function (e) { 
		TermSave();
	}) 	
	
	 //改变上移下移按钮状态
	changeUpDownStatus=function(rowIndex)
	{
		if(rowIndex==0){
			$('#btnUp').linkbutton('disable');
		}
		else{
			$('#btnUp').linkbutton('enable');
		}
		var rows = $('#mygrid').datagrid('getRows');
		if ((rowIndex+1)==rows.length){
			$('#btnDown').linkbutton('disable');
		}
		else{
			$('#btnDown').linkbutton('enable');
		}
	}

	
	 //获取所有已选术语的信息
	GetChoseTermStr=function()
	{
		var ids = [];
		var datas=$('#mygrid').datagrid('getRows');
		for(var i=0; i<datas.length; i++){
			if (datas[i].MKBTPDRowId=="")
			{ 
				var str=datas[i].MKBTRowId	
				ids.push(str);    //id 串
			}
		}
		var idsStr=ids.join(',')
		return idsStr
	}
	
	//获取所有已选治疗手术
	GetSearchTermStr=function ()
	{
		var ids = [];
		var datas=$('#mygrid').datagrid('getRows');
		for(var i=0; i<datas.length; i++){
			var str="<"+datas[i].MKBTRowId+">"
			ids.push(str);    //id 串
		}
		var idsStr=ids.join('^')
		return idsStr
	}
	
	//未选属性列表
	InitUnSelList=function()
	{
		var termStr=GetSearchTermStr();
		var unTermColumns=[[ 
					  { field: 'ck', checkbox: true, width: '30' },  //复选框  	
					  {field:'MKBTDesc',title:'描述',width:150}, 
					  {field:'MKBTCode',title:'代码',width:100}, 
					  {field:'MKBTRowId',title:'MKBTRowId',hidden:true}
					  ]];


		$('#UnSelGrid').datagrid({ 
			width:'100%',
			height:'100%', 
			pagination: true, 
			pageSize:PageSizePop,
			pageList:[5,10,12,15,20,25,30,50,75,100,200,300,500,1000],
			toolbar:'#mywintbar',
			fitColumns: true,
			loadMsg:'数据装载中......',
			autoRowHeight: true,
			url:$URL,
			queryParams:{
				ClassName:"web.DHCBL.MKB.MKBTermProDetail",
				QueryName:"GetUnSelTermList",
				property : property,
				termStr:termStr
			},
			singleSelect:false,
			idField:'MKBTRowId', 
			rownumbers:false,
			fit:true,
			remoteSort:false,
			//sortName:"EpisodeID",
			columns:unTermColumns,
			//onClickRow: ClickProGrid,
			onLoadSuccess:function(data){
				//隐藏行选择数，只按默认显示15个
				//$(".pagination-page-list").hide();
			},
			onLoadError:function(){
			}
		});
	}
	
	//属性搜索方法
	TermSearch=function()
	{
		var termStr=GetSearchTermStr();
		//var desc=$.trim($('#TextDesc').searchbox('getValue'));
		var desc=$.trim($('#TextDesc').val());
		$('#UnSelGrid').datagrid('load',  {
			ClassName:"web.DHCBL.MKB.MKBTermProDetail",
			QueryName:"GetUnSelTermList",			
			'desc':desc,	
			'property':property,
			'termStr':termStr
		});
		$('#UnSelGrid').datagrid('unselectAll');		
	}
	
	//属性重置方法
	TermReset=function()
	{
		var termStr=GetSearchTermStr();
		//$("#TextDesc").searchbox('setValue', '');
		$("#TextDesc").val("");
		$('#UnSelGrid').datagrid('load',  {
			ClassName:"web.DHCBL.MKB.MKBTermProDetail",
			QueryName:"GetUnSelTermList",			
			'property':property,
			'termStr':termStr
		});
		$('#UnSelGrid').datagrid('unselectAll');		
	}
			
	//属性保存方法
	TermSave=function()
	{
		var rows = $('#UnSelGrid').datagrid('getSelections');	
		//已选列表插入选中数据
		if (rows.length==0)
		{
			$.messager.alert('错误提示','没有要保存的数据!',"error");
			return;
		}
		
		var deleteRows = []; 
		var rows = $('#UnSelGrid').datagrid('getSelections');	
		//已选列表插入选中数据
		for(var i=0; i<rows.length; i++){
			deleteRows.push(rows[i]);		
			$("#mygrid").datagrid("appendRow", {
					opt:'',
					MKBTPDRowId:"",
					MKBTPDSequence:"",
					MKBTRowId:rows[i].MKBTRowId,
					MKBTDesc:rows[i].MKBTDesc,
					MKBTCode:rows[i].MKBTCode 
				});
			$('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  //操作列显示删除按钮

		}
		SaveFunLib();
		
		//未选列表移除选中数据
		for(var i =0;i<deleteRows.length;i++){    
			var index = $('#UnSelGrid').datagrid('getRowIndex',deleteRows[i]);
			$('#UnSelGrid').datagrid('deleteRow',index); 
		}
	}
	

	///上移下移
	OrderFunLib=function(type)
	{            
		//更新
		var row = $("#mygrid").datagrid("getSelected"); 
		if (!(row))
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}	   
		var index = $("#mygrid").datagrid('getRowIndex', row);	

		mysort(index, type, "mygrid")
		
		//改变上移、下移按钮的状态
		var nowrow = $('#mygrid').datagrid('getSelected');  
		var rowIndex=$('#mygrid').datagrid('getRowIndex',nowrow);  
		changeUpDownStatus(rowIndex)
	
		//设置删除按钮图标
		$('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'}); 
		
		//遍历列表
		var order=""
		var rows = $('#mygrid').datagrid('getRows');	
		for(var i=0; i<rows.length; i++){	
			var id =rows[i].MKBTPDRowId; 
			if (order!=""){
				order = order+"^"+id
			}else{
				order = id
			}
			
		}
		//保存拖拽后的顺序
		$.m({
			ClassName:"web.DHCBL.MKB.MKBTermProDetail",
			MethodName:"SaveDragListOrder",
			order:order
		},function(txtData){
			//alert(order+txtData)
		});		
		
	}
	
	//上移下移置顶
	mysort=function(index, type, gridname) 
	{
		if ("up" == type) {
			if (index != 0) {
				var toup = $('#' + gridname).datagrid('getData').rows[index];
				var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
				$('#' + gridname).datagrid('getData').rows[index] = todown;
				$('#' + gridname).datagrid('getData').rows[index - 1] = toup;
				$('#' + gridname).datagrid('refreshRow', index);
				$('#' + gridname).datagrid('refreshRow', index - 1);
				$('#' + gridname).datagrid('selectRow', index - 1);
			}
		} 
		else if ("down" == type) {
			var rows = $('#' + gridname).datagrid('getRows').length;
			if (index != rows - 1) {
				var todown = $('#' + gridname).datagrid('getData').rows[index];
				var toup = $('#' + gridname).datagrid('getData').rows[index + 1];
				$('#' + gridname).datagrid('getData').rows[index + 1] = todown;
				$('#' + gridname).datagrid('getData').rows[index] = toup;
				$('#' + gridname).datagrid('refreshRow', index);
				$('#' + gridname).datagrid('refreshRow', index + 1);
				$('#' + gridname).datagrid('selectRow', index + 1);
			}
		}
		else { //置顶
			if (index != 0) {
				var toup = $('#' + gridname).datagrid('getData').rows[index];
				$('#' + gridname).datagrid('insertRow',{
					index: 0, // index start with 0
					row: toup
				});
				$('#' + gridname).datagrid('deleteRow', index+1);
				$('#' + gridname).datagrid('selectRow', 0);
			}	
		}
	}	
	
 	//引用列表型术语的弹出窗
	TopListWin=function() 
	{ 
		$("#myWin").show();	
		//$("#TextDesc").searchbox('setValue', '');
		$("#TextDesc").val("");
		var myWin = $HUI.dialog("#myWin",{
			width:460,
			height:420,
			resizable:true,
			title:'新增术语条目',
			iconCls:'icon-w-add',
			modal:false,  //遮盖
			buttonAlign : 'center'
			/*buttons:[{
				text:'保存',
				id:'save_term_btn',
				handler:function(){
					TermSave();
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]*/
		});	
		InitUnSelList();
	}


	//重置方法
	ClearFunLib=function()
	{
		$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
		$('#mygrid').datagrid('unselectAll');
		//上移下移按钮改为可用
		$('#btnUp').linkbutton('enable');
		$('#btnDown').linkbutton('enable');		

	}

	///新增、更新
	SaveFunLib=function()
	{	
		var addIds=GetChoseTermStr();
		if (addIds=="")
		{
			$.messager.alert('错误提示','列表数据不能为空!',"error");
			return;
		}

		$.ajax({
			url:SAVE_CHECK_ACTION_URL,  
			data:{
				"property":property,
				"addTermIds":addIds
			},  
			type:"POST",   
			//dataType:"TEXT",  
			success: function(data){
					  var data=eval('('+data+')'); 
					  if (data.success == 'true') {
						/*$.messager.show({ 
						  title: '提示消息', 
						  msg: '保存成功', 
						  showType: 'show', 
						  timeout: 1000, 
						  style: { 
							right: '', 
							bottom: ''
						  } 
						}); */
					  	$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
						$("#myWin").dialog('close');
						$('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
					  } 
					  else { 
						var errorMsg ="保存失败！"
						if (data.info) {
							errorMsg =errorMsg
						}
						 $.messager.alert('操作提示',errorMsg,"error");
			
					}			
			}  
		})



	}

	///删除
	DelData=function(id)
	{ 
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){	
				$.ajax({
					url:DELETE_ACTION_URL,  
					data:{
						"id":id  
					},  
					type:"POST",   
					success: function(data){
							var data=eval('('+data+')'); 
							if (data.success == 'true') {
								/*$.messager.show({ 
								  title: '提示消息', 
								  msg: '删除成功', 
								  showType: 'show', 
								  timeout: 1000, 
								  style: { 
									right: '', 
									bottom: ''
								  } 
								}); */
								$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
								ClearFunLib();
	
							} 
							else { 
								var errorMsg ="删除失败！"
								if (data.info) {
									errorMsg =errorMsg+ '<br/>错误信息:' + data.info
								}
								$.messager.alert('操作提示',errorMsg,"error");
					
							}			
					}  
				})
			}
		});
		
	}
	
	///删除全部
	DelAllData=function(id)
	{ 
		$.messager.confirm('提示', '确定要删除全部数据吗?', function(r){
			if (r){	
				$.ajax({
					url:DELETE_ALL_ACTION_URL,  
					data:{
						"property":property  
					},  
					type:"POST",   
					success: function(data){
							var data=eval('('+data+')'); 
							if (data.success == 'true') {
								/*$.messager.show({ 
								  title: '提示消息', 
								  msg: '删除成功', 
								  showType: 'show', 
								  timeout: 1000, 
								  style: { 
									right: '', 
									bottom: ''
								  } 
								}); */
								$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
								ClearFunLib();
	
							} 
							else { 
								var errorMsg ="删除失败！"
								$.messager.alert('操作提示',errorMsg,"error");
					
							}			
					}  
				})
			}
		});
		
	}	
	
	 //点击预览按钮
    function previewFile(MKBDMPath)
    {
        if(MKBDMPath!="")
        {
            var fileType = (MKBDMPath).split(".")[(MKBDMPath).split(".").length-1];
            var PDFisExists=tkMakeServerCall("web.DHCBL.BDP.BDPUploadFile","IsExistsFile","scripts\\bdp\\MKB\\Doc\\Doc\\"+(MKBDMPath).replace(fileType,"pdf"));
            if(PDFisExists==1)
            {
                fileName=MKBDMPath;
                var filepath = "../scripts/bdp/MKB/Doc/Doc/"+fileName.replace(fileType,"pdf");
                var $parent = self.parent.$;
                var previewWin=$parent("#myWinGuideImage").window({
                    width:1300,
                    height: 520,
                    modal:true,
                    title:fileName
                });
                previewWin.html('<object id="PDFViewObject" type="application/pdf" width="100%" height="100%" data='+filepath+' style="display:block"> <div id="PDFNotKnown">你需要先安装pdf阅读器才能正常浏览文件，请点击<a href="http://get.adobe.com/cn/reader/download/?installer=reader_11.0_chinese_simplified_for_windows" target="_blank">这里</a>下载.</div> </object>');
                previewWin.show();
            }
            else
            {
                /*$.messager.show
                ({
                    title: '提示消息',
                    msg: '不存在pdf预览文件！',
                    showType: 'show',
                    timeout: 1000,
                    style: {
                        right: '',
                        bottom: ''
                    }
                });*/
            	$.messager.popover({msg: '不存在pdf预览文件！',type:'info',timeout: 1000});
            }
        }
        else
        {
            $.messager.alert('错误提示','请先选择一条记录!',"error");
        }
    }
    
    //规则管理按钮
    function CheckMappingDetail(MKBDMPath)
    {
        fileName=MKBDMPath; 
        if ('undefined'!==typeof websys_getMWToken){
			fileName += "&MWToken="+websys_getMWToken()
		}
        var $parent = self.parent.$;
        var previewWin=$parent("#myWinGuideImage").window({
        	iconCls:'icon-w-paper',
	        width:1300,
            height: 520,
			resizable:true,
			collapsible:false,
			minimizable:false,
            modal:true,
            title:"规则管理",
            content:'<iframe id="timeline" frameborder="0" src="'+fileName+'" width="100%" height="99%" ></iframe>'
        });
         previewWin.show();
        		
    }
    //查看版本
    SeeVersion=function(){
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var url='dhc.bdp.mkb.mkbversion.csp?MKBVDataFlag=User.MKBTerm'+ProConfig+'&MKBVDataID='+id
		if ('undefined'!==typeof websys_getMWToken){
			url += "&MWToken="+websys_getMWToken()
		}
		var id=record.MKBTRowId
		var $parent = self.parent.$; 
		var versionWin = $parent("#myWinVersion").window({
			iconCls:'icon-w-paper',
			resizable:true,
			collapsible:false,
			minimizable:false,
			title:'查看版本',
			modal:true,
			content:'<iframe id="timeline" frameborder="0" src="'+url+'" width="100%" height="99%" ></iframe>'
		});
		versionWin.show(); 
	}
	//查看日志
	SeeChangeLog=function(){
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var url='dhc.bdp.mkb.mkbdatachangelog.csp?ClassName=User.MKBTerm'+ProConfig+'&ObjectReference='+id
		if ('undefined'!==typeof websys_getMWToken){
			url += "&MWToken="+websys_getMWToken()
		}
		var id=record.MKBTRowId
		var $parent = self.parent.$;  
		var logWin = $parent("#myWinChangeLog").window({
			iconCls:'icon-w-paper',
			resizable:true,
			collapsible:false,
			minimizable:false,
			title:'查看日志',
			modal:true,
			content:'<iframe id="timeline" frameborder="0" src="'+url+'" width="100%" height="99%" ></iframe>'
		});
		logWin.show();
	}
	
};
$(init);
