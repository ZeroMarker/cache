/// 名称: 医用知识库 -引用属性格式的属性内容维护
/// 描述: 包含增删改上移下移等功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2018-04-03
 
var init = function(){
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
	
	//列表datagrid
	$HUI.tree('#catTree',{
		url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetSourseSingleTermJson&property="+property,
		lines:true,  //树节点之间显示线条
		autoSizeColumn:false,
		checkbox:false,
		id:'id',//这里的id其实是所选行的idField列的值
		cascadeCheck:true,  //是否级联检查。默认true  菜单特殊，不级联操作		
		animate:false,   //是否树展开折叠的动画效果
		onLoadSuccess:function(data){
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
			content:'<iframe id="timeline" frameborder="0" src="" width="100%" height="99%" ></iframe>'
		});
		logWin.show();
	}

};
$(init);
