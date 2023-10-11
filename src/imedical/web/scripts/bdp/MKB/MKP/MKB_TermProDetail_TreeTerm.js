/// 名称: 医用知识库 -引用属性格式的属性内容维护
/// 描述: 包含增删改上移下移等功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2018-04-03
 
var init = function(){

	var HISUI_SQLTableName="MKB_TermProDetail"+property,HISUI_ClassTableName="User.MKBTermProDetail"+property;
	
	var SAVE_CHECK_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=SaveSelectTermIds";
	var DELETE_ALL_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=DeleteAllSelTerm";
	
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
	//定义弹窗的高度和宽度
	var winwidth=1200,winheight=520
	if (parent.TermID!="")
	{
		winwidth=window.screen.width-100 //定义展开属性内容的宽带
		winheight=window.screen.height-200 //定义展开属性内容的高度
		
	}
	else
	{
		winwidth=parent.parent.$("#myTabContent").width()-60 //定义展开属性内容的宽度
		winheight=parent.parent.$("#myTabContent").height()-40 //定义展开属性内容的高度
	}
	//alert(winwidth+","+winwidth)
	
	//列表datagrid
	$HUI.tree('#catTree',{
		url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=NewGetSourseTreeTermJson&property="+property,
		lines:true,  //树节点之间显示线条
		autoSizeColumn:false,
		checkbox:true,
		id:'id',//这里的id其实是所选行的idField列的值
		cascadeCheck:false,  //是否级联检查。默认true  菜单特殊，不级联操作		
		animate:false,   //是否树展开折叠的动画效果
		onLoadSuccess:function(data){
			$("#FindTreeText").val("")
			$HUI.radio("#myChecktreeFilterCK0").setValue(true)  //初始设置为全部
			/*var catStr=tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetSelTermIdsStr",property)  //获取已选属性的id串
			if (catStr!="")
			{
				var array = catStr.split(',')
				for(var i=0;i<array.length;i++){
					var node= $('#catTree').tree('find',array[i])
					if ((node!=undefined)&(node!=null)&(node!=""))
					{
						$('#catTree').tree('check',node.target)  
					}
				}
			}*/
			if (detailId!="")
        	{
        		var node = $(this).tree('find',detailId);
        		$(this).tree('select', node.target);
        	}
		},
		onBeforeExpand:function(node){
			$(this).tree('expandFirstChildNodes',node)
        },
		onContextMenu: function(e, node){
			e.preventDefault();
			// select the node
			$('#catTree').tree('select', node.target);
			$('#catTree').tree('check', node.target);
			// display context menu
			//添加右键股则管理菜单和文献预览菜单
            var docMenuStr=""
            var detailIdStr=termRowId+"-"+property+":S"+node.id
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
			
            var mygridmm = $('<div style="width:140px;"></div>').appendTo('body');
            //$( menuStr+docMenuStr).appendTo(mygridmm).click(stopPropagation);//右键菜单里 在IE8下点击右键菜单的按钮 ，没有执行点击事件，原因：append的onclick不会触发，用html的可以触发。
            mygridmm.html('<div onclick="SeeVersion()" iconCls="icon-apply-check" data-options="">查看版本</div>' +
	       			'<div onclick="SeeChangeLog()" iconCls="icon-apply-check" data-options="">查看日志</div>'+
	       			menuStr+docMenuStr).click(stopPropagation);
            //mygridmm.menu()
            mygridmm.menu({
			    onClick:function(item){		    	
			    	var itemid=item.id
					if ((item.name=="规则管理")&(itemid!="")&(itemid!=null)&(itemid!=undefined)){	
						SaveFunLib();  //先保存
						var detailIdStr=termRowId+"-"+property+":S"+node.id
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
 
	//添加按钮
	$("#save_btn").click(function (e) { 
		SaveFunLib();
	}) 				
	
	//删除按钮
	$("#del_btn").click(function (e) { 
		DelAllData();
	}) 
	
	//点击树形折叠按钮
	$("#btnTreeCollapse").click(function (e) { 
		$("#catTree").tree('collapseAll')
	})  
	
	//检索框单击选中输入内容 GXP-20211227-改为不实时检索
	/*$('#FindTreeText').bind('click',function(){
		$('#FindTreeText').select()         
	 });*/
	
	//查询按钮 GXP-20211227-改为不实时检索
	/*$("#mytbar").keyup(function(){ 
		var searchStr = $("#FindTreeText").val(); 
		var searchStr =searchStr.toUpperCase();
		//var TextDesc =$.trim($('#FindTreeText').searchbox('getValue')); //检索的描述
		findByRadioCheck("catTree",searchStr,$("input[name='FilterCK']:checked").val())
		
	})*/
	
	 //检索按钮  GXP-20211227-改为不实时检索
	$("#btnSearch").click(function (e) { 
		var searchStr = $("#FindTreeText").val(); 
		var searchStr =searchStr.toUpperCase();
		//var TextDesc =$.trim($('#FindTreeText').searchbox('getValue')); //检索的描述
		findByRadioCheck("catTree",searchStr,$("input[name='FilterCK']:checked").val())    
	 }) 
	
	//术语分类全部、已选、未选
	$HUI.radio("#mytbar [name='FilterCK']",{
        onChecked:function(e,value){
			var searchStr = $("#FindTreeText").val(); 
			var searchStr =searchStr.toUpperCase();
        	findByRadioCheck("catTree",searchStr,$(e.target).attr("value"))
       }
    });
	
	
	///新增、更新
	SaveFunLib=function()
	{	
	    var catStr=tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetSelTermIdsStr",property)  //获取已选属性的id串
		var catStrIds = catStr.split(',')
	
		//var nodes = $('#catTree').tree('getChecked');  //获取选中的节点
	
		var nodes = $('#catTree').tree('getChecked', ['checked','indeterminate']);  //获取选中及不确定的节点

		//获取要添加到属性内容表的术语
		var addIds=""  //要添加的数据
		for (var i = 0; i < nodes.length; i++) {
			//alert(catStrIds.indexOf(nodes[i].id))
			if (catStrIds.indexOf(nodes[i].id)==-1)  //筛选勾选的数据中 还没有存在属性内容表的
			{
				if (addIds!=""){
					var addIds=addIds+","+nodes[i].id
				}
				else{
					var addIds=nodes[i].id
				}	
			}			
			
		}
		//获取要从属性内容表删除的术语
		var uncheckedNodes = $('#catTree').tree('getChecked', 'unchecked');
		
		var deleteIds=""  //要删除的数据
		for (var i = 0; i < uncheckedNodes.length; i++) {
			if (catStrIds.indexOf(uncheckedNodes[i].id)>-1)  //筛选之前是已选的 现在是未选的数据
			{
				if (deleteIds!=""){
					var deleteIds=deleteIds+","+uncheckedNodes[i].id
				}
				else{
					var deleteIds=uncheckedNodes[i].id
				}	
			}			
			
		}	
		
		//alert(addIds+"&"+deleteIds)
		if ((addIds=="")&(deleteIds==""))
		{
			/*$.messager.show({ 
				  title: '提示消息', 
				  msg: '没有发生变动或需要保存的数据!', 
				  showType: 'show', 
				  timeout: 1000, 
				  style: { 
					right: '', 
					bottom: ''
				  } 
				});*/
			$.messager.popover({msg: '没有发生变动或需要保存的数据！',type:'info',timeout: 1000});	
			return;
		}	
		
		$.ajax({
			url:SAVE_CHECK_ACTION_URL,  
			data:{
				"property":property,
				"addTermIds":addIds,
				"deleteTermIds":deleteIds
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
						});*/
					  	$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
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
	
	///删除全部
	DelAllData=function(id)
	{ 
		$.messager.confirm('提示', '确定要删除全部已选数据吗?', function(r){
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
	
	//重置方法
	ClearFunLib=function()
	{
		$("#FindTreeText").val("")
		$HUI.radio("#myChecktreeFilterCK0").setValue(true)  //初始设置为全部
		treeChecked("unchecked", "catTree")
		$("#catTree").tree('reload');  // 重新载入当前页面数据reload();

	}
	
	$HUI.checkbox('#checkAllTerms',{
		onChecked:function (e,value) { 
			treeChecked("checked", "catTree")
			$("#checkAllTitle").html("取消全选");
		},
		onUnchecked:function (e,value) { 
			treeChecked("unchecked", "catTree")
			$("#checkAllTitle").html("全选");
		}
	})	

	//全选反选  
	//参数:selected:Y -全选 ，N-反选 
	//treeMenu:要操作的tree的id；如：id="userTree"  
	function treeChecked(selected, treeMenu) {  
		var roots = $('#' + treeMenu).tree('getChildren');//返回tree的所有根节点数组  
		if (selected=="checked") {  
			for ( var i = 0; i < roots.length; i++) {				
				var node = $('#' + treeMenu).tree('find', roots[i].id);//查找节点  
				$('#' + treeMenu).tree('check', node.target);//将得到的节点选中  
			}  
		} else {  
			for ( var i = 0; i < roots.length; i++) {  
				var node = $('#' + treeMenu).tree('find', roots[i].id);  
				$('#' + treeMenu).tree('uncheck', node.target);  
			}  
		}  
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
                	iconCls:'icon-w-paper',
                    width:winwidth,
                    height: winheight,
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
	        width:winwidth,
            height: winheight,
			resizable:true,
			collapsible:false,
			minimizable:false,
            modal:true,
            title:"规则管理",
            content:'<iframe id="timeline" frameborder="0" src="'+fileName+'" width="100%" height="99%" ></iframe>'
        });
         previewWin.show();
        		
    }
    
    //查看术语的版本
	SeeVersion=function(){
		var record = $("#catTree").tree("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var url='dhc.bdp.mkb.mkbversion.csp?MKBVDataFlag=User.MKBTerm'+ProConfig+'&MKBVDataID='+id
		if ('undefined'!==typeof websys_getMWToken){
			url += "&MWToken="+websys_getMWToken()
		}
		var id=record.id
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
	//查看术语的日志
	SeeChangeLog=function(){
		var record = $("#catTree").tree("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var url='dhc.bdp.mkb.mkbdatachangelog.csp?ClassName=User.MKBTerm'+ProConfig+'&ObjectReference='+id
		if ('undefined'!==typeof websys_getMWToken){
			url += "&MWToken="+websys_getMWToken()
		}
		var id=record.id
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
