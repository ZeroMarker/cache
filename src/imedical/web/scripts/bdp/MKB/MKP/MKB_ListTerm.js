// / 名称: 知识点维护-列表型 
// / 描述: 当属性为列表时，是列表子术语库维护
// / 编写者: 基础数据平台组-丁亚男 
// / 编写日期: 2018-03-22
//document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ChinesePY.js"> </script>');
//document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/FunLibUI.js"> </script>');
//document.write('<script type="text/javascript" src="../scripts/bdp/MKB/MKP/datagrid-detailview.js"> </script>');
//document.write('<script type="text/javascript" src="../scripts/bdp/MKB/MKP/MKB_KnoExpression.js"></script>');

var init = function(){
	
	/*var ValueExp = tkMakeServerCall("web.DHCBL.MKB.MKBTerm", "GetValueExp", menuid);
	//var base = ValueExp.split("=")[1];
	var base="5"*/
	
	var MKBTBFlag = tkMakeServerCall("web.DHCBL.MKB.MKBTermBase", "GetFlagById",base)
	var basedesc = tkMakeServerCall("web.DHCBL.MKB.MKBTerm", "getTermDesc",base)
	if (basedesc.length>18){
		basedesc=basedesc.substr(0,16)+"..."
	}
	var CatDesc=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase", "GetCatDescById",base)  //获取知识库分类描述
	//alert(basedesc)
	//alert(base)
	//var base="1"
	///判断是列表型还是树形
	//var basetype= tkMakeServerCall("web.DHCBL.MKB.MKBTerm", "GetBaseTypeByID",base) 
	var termdr=""
	var termdesc=""   //术语条目描述
	var propertyid=""; //术语属性选中行的属性id
	var propertyresid=""; //术语属性保存过后返回的属性id
	var indexExtendProConfig=""; 
	var indexPropertyConfig="";
	var contenturl=""
	var propertyName=""
	var protitle="属性维护"
	var protitletip="属性维护"
	var SaveProTermID="" //保存的属性的术语id，用来判断是否首次进入界面或者检索
	var firstflag="Y"   //初次进入界面标志
	/*--------------诊断维护类方法的URL-------------------*/
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=SaveData&pEntityName=web.Entity.MKB.MKBTerm";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=DeleteData";
	//封闭
	var CLOSE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=CloseData";
	//解除封闭
	var CANCELCLOSE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=CancelCloseData";
	
	/*--------------诊断属性类方法的URL-------------------*/
	var PROPERTY_DELETE_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProperty&pClassMethod=DeleteData";	
	var PROPERTY_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProperty&pClassMethod=SaveEntity&pEntityName=web.Entity.MKB.MKBTermProperty";
	
	/*--------------术语扩展属性维护类方法的URL-------------------*/
	var EXTENDPRO_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBTermExtendPro&pClassMethod=SaveEntity&pEntityName=web.Entity.MKB.MKBTermExtendPro";
	var EXTENDPRO_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermExtendPro&pClassMethod=DeleteData";
	
	/*--------------属性复制到本术语的URL-------------------*/
	var COPY_SELF_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProperty&pClassMethod=CopyToSelf"
	
	/*--------------术语复制的URL-------------------*/
	var COPY_TERM_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=CopyTerm"
	//显示、隐藏左侧列表
	if(((LeftGridFlag=="false")||(LeftGridFlag==false))&&(LeftGridFlag!==""))
	{
		$('#layout .layout-panel-west').css('display','none');
		$('#layout').layout('remove','east');
		//$('#layout .layout-panel-east').css('display','none');
		/*console.log(document.getElementsByClassName("layout-expand-east")[0])
		document.getElementsByClassName("layout-expand-east")[0].style.display="none";
		console.log(document.getElementsByClassName("layout-expand-east")[0])*/
		$("#layout").layout("resize");
		var CDSSFlag=true
	}
	else
	{
		$('#layout .layout-panel-west').css('display',''); 
		$("#layout").layout("resize");
		$('#layout').layout('collapse','east');
		var CDSSFlag=false
		 
	}
	//疾病、检查等知识库的术语弹窗中心词从下拉框选取
	if (basedesc=="疾病")
	{
		$('#MKBTDesc').combobox({
			url :$URL+"?ClassName=web.CDSS.CMKB.DiseaseDict&QueryName=GetDataForCmb1&q=&ResultSetType=array",
			valueField: 'DiseaseName',
			textField: 'DiseaseName',
			mode:'remote'
		})
	}
	else if(basedesc=="检查")
	{
		$('#MKBTDesc').combobox({
			url :$URL+"?ClassName=web.CDSS.CMKB.ExamDict&QueryName=GetDataForCmb1&q=&ResultSetType=array",
			valueField: 'ExamName',
			textField: 'ExamName'
		})
	}
	else if(basedesc=="手术")
	{
		$('#MKBTDesc').combobox({
			url :$URL+"?ClassName=web.CDSS.CMKB.OperationDict&QueryName=GetDataForCmb1&q=&ResultSetType=array",
			valueField: 'OperationName',
			textField: 'OperationName',
			mode:'remote'
		})
	}
	else if(basedesc=="检验")
	{
		$('#MKBTDesc').combobox({
			url :$URL+"?ClassName=web.CDSS.CMKB.LabInspectionDict&QueryName=GetDataForCmb1&q=&ResultSetType=array",
			valueField: 'LabName',
			textField: 'LabName'
		})
	}
	else
	{
		$('#MKBTDesc').validatebox()
	}

	
	
	//定义弹窗的高度
	if (TermID!="")
	{
		var winwidth=window.screen.width-100 //定义展开属性内容的宽带
		var winheight=window.screen.height-200 //定义展开属性内容的高度
		
	}
	else
	{
		var winwidth=parent.$("#myTabContent").width()-60 //定义展开属性内容的宽度
		var winheight=parent.$("#myTabContent").height()-40 //定义展开属性内容的高度
	}
	/** *****************************************诊断树形、列表模块公共部分******************************************************************************* */	
	//添加右键规则管理菜单
	var rightMenuInfos=tkMakeServerCall('web.DHCBL.MKB.MKBKLMappingDetail','CreateRightMenu',base);
	var menuStr=""
	if (rightMenuInfos!="")
	{
		var rightMenuInfo=rightMenuInfos.split("[A]")
		for (var i = 0; i <rightMenuInfo.length; i++) {
			var rightMenu =rightMenuInfo[i];  //右键菜单
			var rightMenu=eval('(' + rightMenu + ')');
			//alert(rightMenu)
			/*$('#myMenu').menu('appendItem', {
				text : rightMenu.MKBKMBDesc,
				name:"规则管理",
				iconCls:"icon-apply-opr",
				id:rightMenu.MKBKMBRowId
			});*/		
			menuStr=menuStr+'<div id='+rightMenu.MKBKMBRowId+' name="规则管理" iconCls="icon-set-paper" data-options="">'+rightMenu.MKBKMBDesc+'</div>'			
		}
		menuStr='<div iconCls="icon-batch-cfg"><span>规则管理</span><div style="width:200px;">'+menuStr+'</div></div>'
	}
	 //规则管理按钮
    function CheckMappingDetail(MKBDMPath)
    {
        fileName=MKBDMPath; 
        if ('undefined'!==typeof websys_getMWToken){
            fileName += "&MWToken="+websys_getMWToken()
        }
        var $parent = $;
        var previewWin=$parent("#myWinGuideImage").window({
	        width:winwidth,
            height: winheight,
			resizable:true,
			collapsible:false,
			minimizable:false,
            modal:true,
            title:"规则管理",
            iconCls:'icon-w-paper',
            content:'<iframe id="timelineGuide" frameborder="0" src="'+fileName+'" width="100%" height="99%" ></iframe>'
        });
         previewWin.show();
        		
    }
	 //点击预览按钮
    function previewFile(MKBDMPath)
    {
        if(MKBDMPath!="")
        {
            var fileType = (MKBDMPath).split(".")[(MKBDMPath).split(".").length-1];
			var fileName = MKBDMPath;				
            var PDFisExists=tkMakeServerCall("web.DHCBL.BDP.BDPUploadFile","IsExistsFile","scripts\\bdp\\MKB\\Doc\\Doc\\"+(MKBDMPath).replace(fileType,"pdf"));
            if(PDFisExists==1)
            {
                fileName=MKBDMPath;
                var filepath = "../scripts/bdp/MKB/Doc/Doc/"+fileName.replace(fileType,"pdf");
                 var $parent = $;
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
            	//$.messager.popover({msg: '不存在pdf预览文件！',type:'info',timeout: 1000});
				var url = window.location.href.split('csp')[0]
                url = url + "scripts/bdp/MKB/Doc/Doc/" + fileName
				//存在直接下载pdf以外的文件
				if (fileName.split('.')[1] != "pdf") {
					$(".load").attr("href", url);
				} else {
					//如果是pdf则打开浏览器窗口预览保存文件
					window.open(url);     //在同当前窗口中打开窗口
				}
			}
        }
        else
        {
            $.messager.alert('错误提示','请先选择一条记录!',"error");
        }
    }
    
	//中心词 右键复制
    CopyText=function(){
    	var aux = document.createElement("input");
		// 获取复制内容
		//var content =elementId.text()||elementId.val() 
		// 设置元素内容
		aux.setAttribute("value", copytext);
		
		// 将元素插入页面进行调用
		document.body.appendChild(aux);

		// 复制内容
		aux.select();

		// 将内容复制到剪贴板
		document.execCommand("copy");

		// 删除创建元素
		document.body.removeChild(aux);

		//提示
		//alert("复制内容成功：" + aux.value);
    	
    }
    //普通文本复制
    $("#CopyList").click(function(e){
		CopyText()
	})
	/*
	// 扩展按钮：树形和列表分开
	 $("#btnDetailEdit").click(function (e) {
	 	var MainDesc="",SelectTermID=""
			if(basetype=="T"){
				var MainDesc=$.trim($("#TextSearch").combobox('getText'));
				if (MainDesc==""){
					var rowData = $("#mygrid").treegrid("getSelected");
					if (rowData!==null){
					 	SelectTermID=rowData.MKBTRowId
					}
				}
				var url="dhc.bdp.mkb.mkbedittermtree.csp?base="+base+"&SelectTermID="+SelectTermID+"&MainDesc="+MainDesc
			}
			else
			{
				var MainDesc=$.trim($("#TextSearch").combobox('getText'));
				if (MainDesc==""){
					var rowData = $("#mygrid").datagrid("getSelected");
					if (rowData!==null){
					 	SelectTermID=rowData.MKBTRowId
					}
				}
				var url="dhc.bdp.mkb.mkbedittermlist.csp?base="+base+"&SelectTermID="+SelectTermID+"&MainDesc="+MainDesc
			}
			
			$('#myiframeDetailEdit').attr("src",url);
			$("#myWinDetailEdit").show();
			var myWinDetailEdit = $HUI.dialog("#myWinDetailEdit",{
			:'icon-w-edit',
			resizable:true,
			title:'扩展',
			modal:true,
			height:winheight,
			left: 300,
			top:10,
			onClose:function(){
					if(basetype=="T"){
						ClearFunLibTree();
					}
					else
					{
						ClearFunLib();
					}
				}
			});
			 
		 })  
	*/
	//其他按钮
	$('#menuothers').menu({    
		onHide:function(){ 
			$("#ProLocDesc").combotree('hidePanel');
		}  
	}); 
	// 扩展按钮：树形和列表合在一起，用datagrid
	 $("#btnDetailEdit").click(function (e) {
	 		var MainDesc="",SelectTermID=""
			var MainDesc=$("#TextSearch").combobox('getText');
			if (MainDesc==""){
				if(basetype=="T"){
					var rowData = $("#mygrid").treegrid("getSelected");
				}
				else
				{
					var rowData = $("#mygrid").datagrid("getSelected");
				}
				if (rowData!==null){
					 SelectTermID=rowData.MKBTRowId
				}
			}
			var url="dhc.bdp.mkb.mkbedittermtreelist.csp?base="+base+"&SelectTermID="+SelectTermID+"&MainDesc="+MainDesc+"&basetype="+basetype
    		if ('undefined'!==typeof websys_getMWToken){
                url += "&MWToken="+websys_getMWToken()
            }
            $('#myiframeDetailEdit').attr("src",url);
			$("#myWinDetailEdit").show();
			$('#menuothers').menu('hide') //关闭悬浮菜单										 
			var myWinDetailEdit = $HUI.dialog("#myWinDetailEdit",{
			iconCls:'icon-w-paper',
			resizable:true,
			title:'扩展',
			modal:true,
			height:winheight,
			left: 300,
			top:10,
			onClose:function(){
					/*if(basetype=="T"){
						ClearFunLibTree();
					}
					else
					{
						ClearFunLib();
					}*/
				}
			});
			 
		 })  
	
	
	//中心词 右键导入
	DataImport=function(){
		$("#myWinDataImport").show();  
        var url="dhc.bdp.mkb.mkbdataimportpanel.csp?base="+base
        if ('undefined'!==typeof websys_getMWToken){
            url += "&MWToken="+websys_getMWToken()
        }
		var myWinDataImport = $HUI.window("#myWinDataImport",{
			resizable:true,
			collapsible:false,
			minimizable:false,
			iconCls:'icon-w-paper',
			title:'数据导入导出',
			modal:true,
			content:'<iframe id="timelineImport" frameborder="0" src="'+url+'" width="99%" height="98%" scrolling="no"></iframe>'
		});	
	}
	
	//中心词 右键导图
	GuideImage=function(){
		$("#myWinGuideImage").show(); 
        var url="dhc.bdp.mkb.mkbencyclopedia.csp?base="+base+"&id="+termdr 
        if ('undefined'!==typeof websys_getMWToken){
                url += "&MWToken="+websys_getMWToken()
            }
		var myWinGuideImage = $HUI.window("#myWinGuideImage",{
			resizable:true,
			collapsible:false,
			minimizable:false,
			height:winheight,
			width:winwidth,
			iconCls:'icon-w-paper',
			title:'医为百科',//'导图',"dhc.bdp.mkb.mkbencyclopedia.csp?base="+baseid+"&id="+termdr;
			modal:true,
			//content:'<iframe id="timeline" frameborder="0" src="dhc.bdp.mkb.mkbdiagbrowser.csp?termdr='+termdr+'&base='+base+'" width="100%" height="99%" scrolling="no"></iframe>'
			content:'<iframe id="timelineImage" frameborder="0" src="'+url+'" width="100%" height="99%" ></iframe>'
		});	
	}
	
	// 展示全部按钮：树形和列表合在一起
	var closeflag=""
	 $("#btnShowAll").click(function (e) {
	 		if (closeflag=="")
	 		{
	 			closeflag="ALL"
	 		}
	 		else
	 		{
	 			closeflag=""
	 		}
	 		var desc=$("#TextSearch").combobox('getText');
	 		//$("#TextSearch").combobox('setValue', '');
			if(basetype=="T"){
				if (CatDesc.indexOf("分级加载")!= -1)//((MKBTBFlag=="ICD11")||(MKBTBFlag=="KnoClass"))
				{
					$('#mygrid').treegrid('options').url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=SearchTermICD&desc="+encodeURI(desc)+"&base="+base+"&closeflag="+closeflag; 
					$('#mygrid').treegrid('reload')
				}
				else
				{
				 	$('#mygrid').treegrid('options').url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetTreeJson&base="+base+"&id="+"&closeflag="+closeflag,
				 	$('#mygrid').treegrid('reload')
				 	$("#mygrid").treegrid("search", desc)	
				}
				$('#mygrid').treegrid('unselectAll');
			
				/*$('#mygrid').treegrid('options').url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetTreeJson&base="+base+"&id="+"&closeflag="+closeflag, 
				$('#mygrid').treegrid('reload')	*/	
			}
			else
			{
				if ((CatDesc.indexOf("分级加载")!= -1)&(desc!==""))  //(basedesc=="全局化诊断词表")
			    {
			      	$('#mygrid').datagrid('options').url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=SearchTerm"
			    }
			    else
			    {
			      	$('#mygrid').datagrid('options').url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetMyList&sortway="+sortway
			    }
		      	$('#mygrid').datagrid('options').queryParams={'base':base,'desc':desc,'closeflag':closeflag}
				$('#mygrid').datagrid('load');
			   	$('#mygrid').datagrid('unselectAll');
			   
				/*$('#mygrid').datagrid('options').url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetMyList"  //&base="+base+"&sortway="+sortway+"&closeflag="+closeflag, 
				$('#mygrid').datagrid('load',  {
					'base':base,
					'desc':desc,
					'sortway':sortway,
					'closeflag':closeflag
				});
				$('#mygrid').datagrid('unselectAll');*/
			} 
			//是否显示图片
		 	IsShowImg("")
			
		 })
	 //是否显示图片
	 IsShowImg=function(rowData){
	 	if (rowData=="")
	 	{
		 	ClearProperty();
			//清空中间属性列表，变为图片，改变标题
			$('#mylayoutproperty').panel('setTitle','属性列表')
			if (document.getElementById('mygridProperty').style.display=="")   //如果是mygrid加载的状态
			{	
				$('#mygridProperty').datagrid('loadData', { total: 0, rows: [] }); 
				$('#mygridProperty').datagrid('unselectAll');
				document.getElementById('mygridProperty').style.display='none';  //隐藏mygrid
				$("#div-img").show();  //展示初始图片			
			}
			detailId=""  //属性内容id置为空
	 	}
	 	else
	 	{
	 		document.getElementById('mygridProperty').style.display='';  //显示mygridProperty
			$("#div-img").hide();
			termdr=rowData.MKBTRowId
			//设置属性维护标题
			protitletip="中心词："+rowData.MKBTDesc+"  /检索码："+rowData.MKBTPYCode+"  /备注："+rowData.MKBTNote
			protitle='<span class="titleCls">中心词：</span>'+rowData.MKBTDesc+"  "+'<span class="titleCls">/检索码：</span>'+rowData.MKBTPYCode+"  "+'<span class="titleCls">/备注：</span>'+rowData.MKBTNote
			if (protitle.length>150){
				protitle=protitle.substr(0,148)+"..."
			}
			protitle='<span id="protooltip"  class="hisui-tooltip" title="'+protitletip+'" href="javascript:void(0)">'+protitle+'</span>'
			$('#mylayoutproperty').panel('setTitle',protitle)
		 }
	 
	 }
	///禁用、启用属性工具条
	/*ISPToolBarUse=function(type){  
		if (type==true)
		{
			$('#TextSearchProperty').searchcombobox('enable');
			$('#btnSearchProperty').linkbutton('enable');
			$('#btnRelProperty').linkbutton('enable');
			$('#btnAddProperty').linkbutton('enable');
			$('#btnUpdateProperty').linkbutton('enable');
			$('#btnDelProperty').linkbutton('enable');
			$('#btnCopyProperty').linkbutton('enable');
			$('#btnUpProperty').linkbutton('enable');
			$('#btnDownProperty').linkbutton('enable');
			$('#btnFirstProperty').linkbutton('enable');
		}
		else
		{
			$('#TextSearchProperty').searchcombobox('disable');
			$('#btnSearchProperty').linkbutton('disable');
			$('#btnRelProperty').linkbutton('disable');
			$('#btnAddProperty').linkbutton('disable');
			$('#btnUpdateProperty').linkbutton('disable');
			$('#btnDelProperty').linkbutton('disable');
			$('#btnCopyProperty').linkbutton('disable');
			$('#btnUpProperty').linkbutton('disable');
			$('#btnDownProperty').linkbutton('disable');
			$('#btnFirstProperty').linkbutton('disable');
		}
		
	}*/
	
	//配置展示在左侧列表的公有属性列
	var extendInfo=tkMakeServerCall('web.DHCBL.MKB.MKBTerm','GetShowInLeftInfo',base);
	var extend=extendInfo.split("[A]")
	var extendChild =extend[0];  //配置展示在左侧的注册属性id串
	var extendTitle =extend[1];  //配置展示在左侧的注册属性名称
	
	
	// 所选术语的引用数据
	ReferedList=function(MKBTRowId){
	    if(MKBTRowId!="")
	    {
		    var termid=MKBTRowId;
		    var MKBReferFlag="T"
		}
	    else
	    {
		    $.messager.alert('错误提示','请先选择一条记录!',"error");
		    return;
		}
        var url="dhc.bdp.mkb.mkbreferedlist.csp?MKBReferID="+termid+"&MKBReferFlag="+MKBReferFlag
		if ('undefined'!==typeof websys_getMWToken){
            url += "&MWToken="+websys_getMWToken()
        }
        $("#myWinReferedList").show();  
		var myWinReferedList = $HUI.window("#myWinReferedList",{
			resizable:true,
			collapsible:false,
			minimizable:false,   
			title:'引用信息',
			iconCls:'icon-w-paper',
			modal:true,
			content:'<iframe id="myiframeReferedList" name="myiframeReferedList" frameborder="0" src="'+url+'" width="99%" height="98%" scrolling="no"></iframe>'
		});	
	}
	//查看术语的版本
	SeeTermVersion=function(){
		if(basetype=="T")
		{
			var record = $("#mygrid").treegrid("getSelected"); 
		}
		else
		{
			var record = $("#mygrid").datagrid("getSelected");
		}
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var id=record.MKBTRowId
        var url="dhc.bdp.mkb.mkbversion.csp?MKBVDataFlag="+"User.MKBTerm"+base+"&MKBVDataID="+id
        if ('undefined'!==typeof websys_getMWToken){
            url += "&MWToken="+websys_getMWToken()
        }
		$("#myWinVersion").show();  
		var myWinDataImport = $HUI.window("#myWinVersion",{
			resizable:true,
			collapsible:false,
			minimizable:false,
			title:'查看版本',
			iconCls:'icon-w-paper',
			modal:true,
			content:'<iframe id="timelineVersion" frameborder="0" src="'+url+'" width="100%" height="99%" ></iframe>'
		});
	}
	//查看术语的日志
	SeeTermChangeLog=function(){
		if(basetype=="T")
		{
			var record = $("#mygrid").treegrid("getSelected"); 
		}
		else
		{
			var record = $("#mygrid").datagrid("getSelected");
		}
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var id=record.MKBTRowId
		$("#myWinChangeLog").show(); 
        var url="dhc.bdp.mkb.mkbdatachangelog.csp?ClassName="+"User.MKBTerm"+base+"&ObjectReference="+id 
        if ('undefined'!==typeof websys_getMWToken){
            url += "&MWToken="+websys_getMWToken()
        }
		var myWinDataImport = $HUI.window("#myWinChangeLog",{
			resizable:true,
			collapsible:false,
			minimizable:false,
			title:'查看日志',
			iconCls:'icon-w-paper',
			modal:true,
			content:'<iframe id="timelineLog"  style="border:1px solid #C0C0C0;border-radius:4px;"  src="'+url+'" width="99%" height="98%" scrolling="no"></iframe>'
		});
	}
	/** *****************************************诊断树形、列表模块公共部分******************************************************************************* */	
	
		
		
	if(basetype=="T"){	
		/** *****************************************诊断树形模块******************************************************************************* */
		//扩展界面增加、修改、删除之后父界面刷新
		RefreshParent=function(parentid,id){
			if (CatDesc.indexOf("分级加载")!= -1)//((MKBTBFlag=="ICD11")||(MKBTBFlag=="KnoClass"))
			{
				$('#mygrid').treegrid('options').url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=TreeStructure&id="+id+"&base="+base+"&closeflag="+closeflag; 
				$('#mygrid').treegrid('reload')
				Location(id)
			}
			else
			{
			 	if(id==undefined)
			 	{
			 		id=""
			 	}
			 	if(parentid!==undefined)
			 	{
			 		ReloadTreegridNode("mygrid",parentid,id)
			 	}
			 	
			}
		}
		
		//扩展界面单击之后左侧展示树形结构(包括诊断IDC11)
		LocationALL=function(id){
			if (CatDesc.indexOf("分级加载")!= -1)//((MKBTBFlag=="ICD11")||(MKBTBFlag=="KnoClass"))
			{
				
				$('#mygrid').treegrid('options').url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=TreeStructure&id="+id+"&base="+base+"&closeflag="+closeflag; 
				$('#mygrid').treegrid('reload')
				Location(id)
			}
			else
			{
			 	Location(id)	
			}
		}
		
		document.getElementById("btnTreeCollapse").style.display = ""; //显示树形全部折叠按钮
		document.getElementById("btnSwitchSortWay").style.display = "none"; //隐藏切换排序按钮
		document.getElementById("ProLocDesc").style.display = "none"; //隐藏专业科室检索框
		$("#ProLocDesc").next(".combo").css("display", "none");												 
		//点击树形折叠按钮
		$("#btnTreeCollapse").click(function (e) { 
				$("#mygrid").treegrid('collapseAll')
		 })  
		
		//上级节点
		$HUI.combotree('#MKBTLastLevelTree',{
			 url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmb&base="+base+"&closeflag="+closeflag
			,onBeforeExpand:function(node){
				$(this).tree('expandFirstChildNodes',node)
	        }
		});
		//中心词新增按钮
		$("#btnAdd").click(function (e) { 
	
				AddDataTree();
		 })  
		 
		//术语维护查询框
		$('#TextSearch').searchcombobox({ 
			url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+"User.MKBTerm"+base,
			onSelect:function () 
			{	
				$(this).combobox('textbox').focus();
				SearchFunLibTree()  
	        }
		});

		$('#TextSearch').combobox('textbox').bind('keyup',function(e){  
			if (e.keyCode==13){ 
				SearchFunLibTree()  
			}
		}); 

		$("#btnSearch").click(function (e) { 
				SearchFunLibTree();
		})
		//中心词清屏按钮
		$("#btnRel").click(function (e) { 
	
				ClearFunLibTree();
		 })  
		 //查询方法
		SearchFunLibTree=function (){
			var desc=$("#TextSearch").combobox('getText');
			if(desc=="")
			{
				ClearFunLibTree();
				return
			}
			if (CatDesc.indexOf("分级加载")!= -1)//((MKBTBFlag=="ICD11")||(MKBTBFlag=="KnoClass"))
			{
				$('#mygrid').treegrid('options').url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=SearchTermICD&desc="+encodeURI(desc)+"&base="+base+"&closeflag="+closeflag; 
				$('#mygrid').treegrid('reload')
			}
			else
			{
			 	$("#mygrid").treegrid("search", desc)	
			}
			$('#mygrid').treegrid('unselectAll');
			//滚动条滚动到最前
			$('#layoutwest').find('div.datagrid-body').prop('scrollTop',0)
			termdr=""
			//是否显示图片
		 	IsShowImg("")
			
		}
		//清屏方法
		ClearFunLibTree=function (){
			//是否收缩树形标志
			firstflag="Y"
			//加载全部与否的标志
			closeflag=""
			TermID=""
			$("#TextSearch").combobox('setValue', '');
			$('#mygrid').treegrid('options').url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetTreeJson&base="+base+"&id="+"&closeflag=", 
			$('#mygrid').treegrid('reload')
			$('#mygrid').treegrid('unselectAll');
			//滚动条滚动到最前
			$('#layoutwest').find('div.datagrid-body').prop('scrollTop',0)
			termdr=""
			//是否显示图片
		 	IsShowImg("")
		}
		 //点击新增同级节点按钮
		AddSameDataTree = function() {
			$('#MKBTLastLevelTree').combotree('reload')
			$("#myWinTree").show();
			var myWinTree = $HUI.dialog("#myWinTree",{
				iconCls:'icon-w-add',
				resizable:true,
				title:'新增',
				modal:true,
				buttonAlign : 'center',
				buttons:[{
					text:'保存',
					//iconCls:'icon-save',
					id:'save_btn',
					handler:function(){
						SaveFunLibTree("")
					}
				},{
					text:'关闭',
					//iconCls:'icon-cancel',
					handler:function(){
						myWinTree.close();
					}
				}]
			});	
			$('#form-saveTree').form("clear");
			var record = $("#mygrid").treegrid("getSelected"); 
			if (record)
			{
				var ParentNode=$("#mygrid").treegrid("getParent",record.MKBTRowId)
				if (ParentNode)
				{
					$('#MKBTLastLevelTree').combotree('setValue', ParentNode.MKBTRowId);
				}
			}
		}
		 //点击新增同级子节点按钮
		AddDataTree = function() {
			$('#MKBTLastLevelTree').combotree('reload')		
			$("#myWinTree").show();
			var myWinTree = $HUI.dialog("#myWinTree",{
				iconCls:'icon-w-add',
				resizable:true,
				title:'新增',
				modal:true,
				//height:$(window).height()-70,
				buttonAlign : 'center',
				buttons:[{
					text:'保存',
					//iconCls:'icon-save',
					id:'save_btn',
					handler:function(){
						SaveFunLibTree("")
					}
				},{
					text:'关闭',
					//iconCls:'icon-cancel',
					handler:function(){
						myWinTree.close();
					}
				}]
			});	
			$('#form-saveTree').form("clear");
			var record = $("#mygrid").treegrid("getSelected"); 
			if (record)
			{
				$('#MKBTLastLevelTree').combotree('setValue', record.MKBTRowId);
			}
		}
		
		 //点击修改按钮
		UpdateDataTree=function () {
			$('#MKBTLastLevelTree').combotree('reload')
			var record = $("#mygrid").treegrid("getSelected"); 
			if (!(record))
			{	
				$.messager.alert('错误提示','请先选择一条记录!',"error");
				return;
			}
			var id=record.MKBTRowId
			$.cm({
				ClassName:"web.DHCBL.MKB.MKBTerm",
				MethodName:"OpenData",
				id:id
			},function(jsonData){
				$('#form-saveTree').form("load",jsonData);	
				$("#myWinTree").show(); 
				var myWinTree = $HUI.dialog("#myWinTree",{
					iconCls:'icon-w-edit ',
					resizable:true,
					title:'修改',
					modal:true,
					//height:$(window).height()-70,
					buttons:[{
						text:'保存',
						//iconCls:'icon-save',
						id:'save_btn',
						handler:function(){
							SaveFunLibTree(id)
						}
					},{
						text:'关闭',
						//iconCls:'icon-cancel',
						handler:function(){
							myWinTree.close();
						}
					}]
				});
			});
			
		}
		///新增、更新
		SaveFunLibTree=function (id){		
			if ($.trim($("#MKBTDescTree").val())=="")
			{
				$.messager.alert('错误提示','中心词不能为空!',"error");
				return;
			}
			///上级分类
			if ($('#MKBTLastLevelTree').combotree('getText')=='')
			{
				$('#MKBTLastLevelTree').combotree('setValue','')
			}
			//在修改新增时判断选中的上级是不是本身或者自己的下级
			var comboId=$('#MKBTLastLevelTree').combotree('getValue');
			if(id!=""){
				if(justFlag(comboId,id,"mygrid"))
				{
					return;				
				}
			}
			$('#form-saveTree').form('submit', { 
				url: SAVE_ACTION_URL, 
				onSubmit: function(param){
					param.MKBTRowId = id;
					param.MKBTBaseDR = base;		
				},
				success: function (data) { 
					  var data=eval('('+data+')'); 
					  if (data.success == 'true') {
					  		$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
							/*$.messager.show({ 
							  title: '提示消息', 
							  msg: '提交成功', 
							  showType: 'show', 
							  timeout: 1000, 
							  style: { 
								right: '', 
								bottom: ''
							  } 
							}); */
					  		
							//$('#mygrid').treegrid('reload',comboId);  // 重新载入当前节点的父节点
					  		ReloadTreegridNode("mygrid",comboId,id)
							$('#myWinTree').dialog('close'); // close a dialog
							setTimeout(function(){
								$('#mygrid').treegrid('unselectAll');
								$('#mygrid').treegrid('select',data.id);
								/*var rowData=$('#mygrid').treegrid('getSelected')
								if (rowData!==null){
									InitProTitle(rowData)
								}*/	
							},"500")
							
					  } 
					  else { 
							var errorMsg ="提交失败！"
							if (data.errorinfo) {
								errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
							}
							$.messager.alert('操作提示',errorMsg,"error");
			
					}
	
				} 
			});
		}
		//术语名失去焦点自动生成检索码
		$('#MKBTDescTree').bind('blur',function(){
	           $("#MKBTPYCodeTree").val(Pinyin.GetJPU($('#MKBTDescTree').val()))
	      });
	      
		///删除
		DelDataTree=function (){                  
			var record = $("#mygrid").treegrid("getSelected"); 
			if (!(record))
			{	$.messager.alert('错误提示','请先选择一条记录!',"error");
				return;
			}
			$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
				if (r){			
					$.ajax({
						url:DELETE_ACTION_URL,  
						data:{
							"id":record.MKBTRowId      ///rowid
						},  
						type:"POST",   
						success: function(data){
								  var data=eval('('+data+')'); 
								  if (data.success == 'true') {
								  		$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
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
										//保存历史和频次记录
										RefreshSearchData("User.MKBTerm"+base,record.MKBTRowId,"D","")
										$('#mygrid').treegrid('remove',record.MKBTRowId)
										//ReloadTreegridNode("mygrid","MKBTLastLevelTree",record.MKBTRowId)
										/*$('#mygrid').treegrid('reload',comboId);  // 重新载入当前节点的父节点
										setTimeout(function(){
											if (comboId=="")
											{
												$("#mygrid").treegrid('collapseAll')	
											}
										},"500")*/
										//$('#mygrid').treegrid('unselectAll');  // 清空列表选中数据
										//属性是否显示图片
										IsShowImg("")
								  } 
								  else { 
								  	var errorMsg =""
								  	if (data.info) {																
										if (data.info.indexOf("引用")!=-1)
										{
											/*errorMsg =data.info+ '<br/><font style="color:red;">确定要删除该数据及所有引用数据吗？</font>'
											$.messager.confirm('提示', errorMsg, function(r){
												if (r){
													DelReferDataTree(record.MKBTRowId)
												}
											});*/
											ReferedList(record.MKBTRowId)
										}
										else
										{
											var errorMsg ="删除失败！"
											if (data.info) {
												errorMsg =errorMsg+ '<br/>错误信息:' + data.info
											}
											$.messager.alert('操作提示',errorMsg,"error");
										}
								  	}
								}			
						}  
					})
				}
		});		
		}
		
		/*///删除引用数据
		DelReferDataTree=function(referID)
		{        
			if (referID=="")
			{
				return
			}
	
			var data=tkMakeServerCall('web.DHCBL.MKB.MKBTerm','DeleteDataAndRefer',referID);
			  var data=eval('('+data+')'); 
			  if (data.success == 'true') {
			  	    $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					$('#mygrid').treegrid('remove',referID)
			  } 
			  else { 
					var errorMsg ="删除失败！"
					if (data.info) {
						errorMsg =errorMsg+ '<br/>错误信息:' + data.info
					}
					$.messager.alert('操作提示',errorMsg,"error");
		
		
			}					
	
		}*/
		///封闭
		CloseTermTree=function (){
			var record = $("#mygrid").treegrid("getSelected");  
			if (!(record))
			{	$.messager.alert('错误提示','请先选择一条记录!',"error");
				return;
			}
			
			$.messager.confirm('提示', '确定要封闭所选的数据吗?', function(r){
				if (r){	
					$.ajax({
						url:CLOSE_ACTION_URL,  
						data:{
							"id":record.MKBTRowId      ///rowid
						},  
						type:"POST",   
						success: function(data){
								  var data=eval('('+data+')'); 
								  if (data.success == 'true') {
								  		$.messager.popover({msg: '封闭成功！',type:'success',timeout: 1000});
										$('#mygrid').treegrid('remove',record.MKBTRowId)
										//属性是否显示图片
										IsShowImg("")
								  } 
								  else { 
										var errorMsg ="封闭失败！"
										if (data.info) {
											errorMsg =errorMsg+ '<br/>错误信息:' + data.info
										}
										$.messager.alert('操作提示',errorMsg,"error");
						
								}			
						}  
					})
				}
			})		
		}
		///解除封闭
		CancelCloseTermTree=function (){
			var record = $("#mygrid").treegrid("getSelected");  
			if (!(record))
			{	$.messager.alert('错误提示','请先选择一条记录!',"error");
				return;
			}
			var comboId=record.MKBTLastLevelF;
			var id=record.MKBTRowId;
			$.messager.confirm('提示', '确定要解除封闭所选的数据吗?', function(r){
				if (r){	
					$.ajax({
						url:CANCELCLOSE_ACTION_URL,  
						data:{
							"id":record.MKBTRowId      ///rowid
						},  
						type:"POST",   
						success: function(data){
								  var data=eval('('+data+')'); 
								  if (data.success == 'true') {
								  		$.messager.popover({msg: '解除封闭成功！',type:'success',timeout: 1000});
										ReloadTreegridNode("mygrid",comboId,id)
								  } 
								  else { 
										var errorMsg ="解除封闭失败！"
										if (data.info) {
											errorMsg =errorMsg+ '<br/>错误信息:' + data.info
										}
										$.messager.alert('操作提示',errorMsg,"error");
						
								}			
						}  
					})
				}
			})		
		}
		/** 复制选中术语 */
		CopyTreeTerm = function() {
				var record = $("#mygrid").treegrid("getSelected"); 
				//上级节点的id
			    var comboId=record.MKBTLastLevelF   
				if (!(record)) {
					$.messager.alert('提示','请选择复制的知识!',"warning");
					return;
				} 
				termdr = record.MKBTRowId;
				var termdesc = record.MKBTDesc;
				$("#myWinCopyTerm").show(); 
				var myWinCopyTerm = $HUI.dialog("#myWinCopyTerm",{
					iconCls:'icon-w-paper',
					resizable:true,
					title:'复制'+termdesc,
					modal:true,
					//height:$(window).height()-70,
					buttonAlign : 'center',
					buttons:[{
						text:'复制格式',
						//iconCls:'icon-save',
						//id:'save_btn_CopyTreeTermForm',
						handler:function(){
								if ($.trim($("#CopyMKBTDesc").val())=="")
								{
									$.messager.alert('错误提示','中心词不能为空!',"error");
									return;
								}
								$('#form-save-CopyTerm').form('submit', { 
									url: COPY_TERM_URL, 
									onSubmit: function(param){
										param.copytermdr = termdr,
										param.copyall = ""
									},
									success: function (data) { 
									  var data=eval('('+data+')'); 
									  if (data.success == 'true') {
									  	$.messager.popover({msg: '复制格式成功！',type:'success',timeout: 1000});
										/*$.messager.show({ 
										  title: '提示消息', 
										  msg: '复制格式成功', 
										  showType: 'show', 
										  timeout: 1000, 
										  style: { 
											right: '', 
											bottom: ''
										  } 
										}); */
										//$('#mygrid').treegrid('reload');  // 重新载入当前页面数据 
									  	/*$('#mygrid').treegrid('reload',comboId);  // 重新载入当前节点的父节点
										setTimeout(function(){
											if (comboId=="")
											{
												$("#mygrid").treegrid('collapseAll')	
											}
										},"500")*/
									  	ReloadTreegridNode("mygrid",comboId,"")  //重新加载改动的数据
										ClearProperty();  // 重新载入当前页面数据  
									  } 
									  else { 
										var errorMsg ="更新失败！"
										if (data.errorinfo) {
											errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
										}
										 $.messager.alert('操作提示',errorMsg,"error");
							
									}
	
								} 
							}); 
							myWinCopyTerm.close();
						}
					},{
						text:'完全复制',
						//iconCls:'icon-save',
						handler:function(){
							if ($.trim($("#CopyMKBTDesc").val())=="")
							{
								$.messager.alert('错误提示','中心词不能为空!',"error");
								return;
							}
							$('#form-save-CopyTerm').form('submit', { 
									url: COPY_TERM_URL, 
									onSubmit: function(param){
										param.copytermdr = termdr,
										param.copyall = "1"
									},
									success: function (data) { 
									  var data=eval('('+data+')'); 
									  if (data.success == 'true') {
									  	$.messager.popover({msg: '完全复制成功！',type:'success',timeout: 1000});
										/*$.messager.show({ 
										  title: '提示消息', 
										  msg: '完全复制成功', 
										  showType: 'show', 
										  timeout: 1000, 
										  style: { 
											right: '', 
											bottom: ''
										  } 
										}); */
										//$('#mygrid').treegrid('reload');  // 重新载入当前页面数据 
									  	/*$('#mygrid').treegrid('reload',comboId);  // 重新载入当前节点的父节点
										setTimeout(function(){
											if (comboId=="")
											{
												$("#mygrid").treegrid('collapseAll')	
											}
										},"500")*/
									  	ReloadTreegridNode("mygrid",comboId,"")  //重新加载改动的数据
										ClearProperty();  // 重新载入当前页面数据  
									  } 
									  else { 
										var errorMsg ="更新失败！"
										if (data.errorinfo) {
											errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
										}
										 $.messager.alert('操作提示',errorMsg,"error");
							
									}
	
								} 
							}); 
							myWinCopyTerm.close();
						}
					}]
				});	
				$('#form-save-CopyTerm').form("clear");
				
		}
		// 包含部位中心词的相关诊断
		RelatedTerm=function(){
			var MKBTBFlag = tkMakeServerCall("web.DHCBL.MKB.MKBTermBase", "GetFlagById",base)
	        if(MKBTBFlag == "Part")
	        {
	            var baseType = "part"
	        }
	        else if(MKBTBFlag == "Pathogeny")
	        {
	            var baseType = "dis"
	        }
	        else
	        {
	            var baseType = ""
	        }
			var term=$('#mygrid').datagrid('getSelected');
		    if(term)
		    {
			    var termid=term.MKBTRowId;
			}
		    else
		    {
			    $.messager.alert('错误提示','请先选择一条记录!',"error");
			    return;
			}
			$("#myWinRelatedTerm").show(); 
            var url="dhc.bdp.mkb.mkbasstermforcr.csp?termid="+termid+"&baseType="+baseType
            if ('undefined'!==typeof websys_getMWToken){
                url += "&MWToken="+websys_getMWToken()
            } 
			var myWinRelatedTerm = $HUI.window("#myWinRelatedTerm",{
				resizable:true,
				collapsible:false,
				minimizable:false,   
				title:'相关诊断',
				iconCls:'icon-w-paper',
				modal:true,
				content:'<iframe id="myiframeRelatedTerm" name="myiframeRelatedTerm" frameborder="0" src="'+url+'" width="99%" height="98%" scrolling="no"></iframe>'
			});	
		}
		//在辅助功能区复制，在此处粘贴节点调用的方法
	    PasteNode=function(type){
	    	var record = $("#mygrid").treegrid("getSelected"); 
			if (record)
			{
				var data=tkMakeServerCall('web.DHCBL.MKB.MKBCopyTree','CopyNode',"",record.id,type);
				var data=eval('('+data+')'); 
				if (data.success == 'true') {
					$.messager.popover({msg: '复制节点粘贴成功！',type:'success',timeout: 1000});
				} 
				else { 
					var errorMsg =""
					if (data.info) {
						errorMsg =errorMsg+ '错误信息:' + data.info
					}
					$.messager.alert('操作提示',errorMsg,"error");
		
				}	
				ClearFunLibTree();
			}
	    }
	    Location=function(id){
	    	if ((id=="")||(id==null)) return
	    	$("#mygrid").treegrid("expandTo", id)
	    	$("#mygrid").treegrid('select', id)
	    }
		///左侧列表
		var ISPToolBarUsetype;
		var columns =[[  
					  {field:'MKBTRowId',title:'MKBTRowId',width:80,sortable:true,hidden:true},
					  {field:'MKBTCode',title:'代码',width:120,sortable:true,hidden:true},
					  {field:'MKBTDesc',title:'中心词',width:270,sortable:true,
					  	styler: function (value, row, index) {
					  		if(row.MKBTActiveFlag=="N")
					  		{
								 return 'background-color:red;';
					  		} 
				           }
				       },
					  {field:'MKBTSequence',title:'顺序',width:60,sortable:true,hidden:true },
					  {field:'MKBTPYCode',title:'检索码',width:60,sortable:true,hidden:true },
					  {field:'MKBTLastLevel',title:'上级节点',width:80,hidden:true},
					  {field:'MKBTNote',title:'备注',width:80,hidden:true},
					  {field:'MKBTActiveFlag',title:'是否封闭',width:80,hidden:true}
					  ]];
		 //如果有配置属性，则自动生成列
		if (extendChild!="")  
		{
			var colsField = extendChild.split("[N]"); 
			var colsHead = extendTitle.split("[N]"); 
			for (var i = 0; i <colsField.length; i++) {
				var fieldid=colsField[i];
				var labelName=colsHead[i];  //标题
				var comId='Extend'+colsField[i];   //控件id				
				//添加列 方法2
				var column={};  
				column["title"]=labelName;  
				column["field"]=comId;  
				column["width"]=150;  
				column["sortable"]=false; 
				//column["hidden"]=true; 
				columns[0].push(column)
			
			}
		}
		var mygrid = $HUI.treegrid("#mygrid",{
			url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetTreeJson&base="+base+"&id="+"&closeflag="+closeflag,
			ClassTableName:'User.MKBTerm'+base,
			SQLTableName:'MKB_Term',
			columns: columns,  //列信息
			height:$(window).height()-105,   ///需要设置高度，不然数据展开太多时，列头就滚动上去了。
			idField: 'MKBTRowId',
			ClassName: "web.DHCBL.MKB.MKBTerm", //拖拽方法DragNode存在的类
			DragMethodName:"DragNode",
			treeField:'MKBTDesc',  //树形列表必须定义 'treeField' 属性，指明哪个字段作为树节点。		
			autoSizeColumn:false,
			animate:false,     //是否树展开折叠的动画效果
			//fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
			//remoteSort:false,  //定义是否从服务器排序数据。true
	        toolbar:'#mytbar',
			onContextMenu: function(e, row){   //右键菜单
				var $clicked=$(e.target);
				copytext =$clicked.text()||$clicked.val()   //普通复制功能
				e.preventDefault();
	        	$(this).treegrid('select', row.id);
	        	
	        	termdr=row.MKBTRowId
	        	//封闭、取消封闭是否可用
				var CloseTermTreeDisable=false,CancelCloseTermTreeDisable=false
				if (row.MKBTActiveFlag=="N"){
					CloseTermTreeDisable=true
				}
				else
				{
					CancelCloseTermTreeDisable=true
				}
	        	//添加右键规则管理菜单和文献预览菜单
	            var docMenuStr=""
	            var detailIdStr=termdr
				var docMenuInfos=tkMakeServerCall('web.DHCBL.MKB.MKBKLMappingDetail','CreateDocRightMenu',base,detailIdStr);
				if (docMenuInfos!="")
				{
					var docMenuInfo=docMenuInfos.split("[A]")
					for (var i = 0; i <docMenuInfo.length; i++) {
						var docMenu =docMenuInfo[i];  //右键菜单
						var docMenu=eval('(' + docMenu + ')');
						//alert(docMenu)
						docMenuStr=docMenuStr+'<div id='+docMenu.DocPath+' name="文献预览" iconCls="icon-apply-check" data-options="">'+docMenu.DocDesc+'</div>'			
					}
					docMenuStr='<div iconCls="icon-apply-check"><span>文献预览</span><div style="width:500px;">'+docMenuStr+'</div></div>'
				}
				var mygridmm = $('<div style="width:120px;"></div>').appendTo('body')
				
				mygridmm.html('<div onclick="AddSameDataTree()" iconCls="icon-add" data-options="">新增本级</div>' +
	       		'<div onclick="AddDataTree()" iconCls="icon-add" data-options="">新增下级</div>' +
	       		'<div onclick="UpdateDataTree()" iconCls="icon-write-order" data-options="">修改</div>' +
	       		'<div onclick="DelDataTree()" iconCls="icon-cancel" data-options="">删除</div>'+
	       		'<div onclick="CloseTermTree()" iconCls="icon-lockdata" data-options="disabled:'+CloseTermTreeDisable+'" id="CloseTermTree">封闭</div>'+
	       		'<div onclick="CancelCloseTermTree()" iconCls="icon-unlock" data-options="disabled:'+CancelCloseTermTreeDisable+'" id="CancelCloseTermTree">解除封闭</div>'+
	       		'<div onclick="RelatedTerm()" iconCls="icon-apply-check" data-options="">相关诊断</div>'+
	       		'<div onclick="CopyText()" iconCls="icon-copyorder" data-options="">复制文本</div>'+
	       		'<div onclick="CopyTreeTerm()" iconCls="icon-copyorder" data-options="">复制术语</div>'+
	       		'<div onclick="PasteNode(1)" iconCls="icon-paste" data-options="">粘贴当前节点</div>' +
	       		'<div onclick="PasteNode(3)" iconCls="icon-paste" data-options="">粘贴子节点</div>' +
	       		'<div onclick="SeeTermVersion()" iconCls="icon-apply-check" data-options="">查看版本</div>' +
	       		'<div onclick="SeeTermChangeLog()" iconCls="icon-apply-check" data-options="">查看日志</div>' +
	       		'<div onclick="GuideImage()" iconCls="icon-productimage" data-options="">医为百科</div>'+menuStr+docMenuStr
				).click(stopPropagation)

				mygridmm.menu({
				    onClick:function(item){
				    	var itemid=item.id
						if ((item.name=="规则管理")&(itemid!="")&(itemid!=null)&(itemid!=undefined)){	
							var newOpenUrl="../csp/dhc.bdp.mkb.mkbklmappingdetail.csp?mappingBase="+itemid+"&termBase="+base+"&detailIdStr="+detailIdStr
							//window.open(newOpenUrl, 'newwindow', 'height=600, width=1000, top=120, left=260, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no')				
							CheckMappingDetail(newOpenUrl)
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
			},
	        onDblClickRow: function (rowIndex,rowData) {
	        	ClickMygridtree(rowIndex,rowData)
	        },
	        onClickRow: function (rowIndex,rowData) {
	         	ClickMygridtree(rowIndex,rowData)
	        },
			onLoadSuccess:function(data) {
				var searchvalue=$('#TextSearch').combobox('getText')
				//$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
				//ISPToolBarUse(false) ///初始化属性工具条不可用
				$(this).treegrid('enableDnd', data?data.id:null);   //允许拖拽
				if(SaveProTermID=="" )
				{
					if(TermID!=""){
						var desc=tkMakeServerCall("web.DHCBL.MKB.MKBTerm", "GetDesc",TermID);
						$("#mygrid").treegrid("search", desc)
						$('#mygrid').treegrid('select',TermID);
						var rowData=$('#mygrid').treegrid('getSelected')
						if (rowData!==null){
							InitProTitle(rowData)
						}
					}
					else if((searchvalue!="")&(data==null)){
						
						$("#mygrid").treegrid("search", searchvalue)
						/*$('#mygrid').treegrid('unselectAll');
						$('#mygrid').treegrid('selectRow',0);
						var rowData=$('#mygrid').treegrid('getSelected')
						if (rowData!==null){
							InitProTitle(rowData)
						}*/
					}
				}
				if((firstflag=="Y")&(TermID==""))
				{
					$("#mygrid").treegrid('collapseAll') //初次加载树形收缩
				}
				firstflag=""
			
			},
			onBeforeExpand:function(row){
                $(this).treegrid('options').url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetTreeJson&base="+base+"&id="+row.id;              
				$(this).treegrid('expandFirstChildNodes',row.id)
			},
	        onDrop: function(targetRow, sourceRow, point){
	        	$(this).treegrid('enableDnd') //允许拖拽
			},
			onStopDrag: function(node){
				var pNode = $(this).treegrid("getParent",node.id)
				if(pNode)
				{
					$(this).treegrid('reload',pNode.id)
				}
				
			},
	        onBeforeSelect:function(node){
	        	  $("#TextSearch").combobox("panel").panel("close")

	        }
		});
		ShowUserHabit('mygrid');
		//标题
		$("#mygrid").treegrid("getPanel").panel("setTitle",basedesc)
		
		//选中术语条目后初始化属性列表
		InitProTitle=function(rowData){
			//是否显示图片
		 	IsShowImg(rowData)
    	  	//ISPToolBarUse(true)
         	$("#TextSearchProperty").combobox('setValue', ''); 
    	  	
    	  	InitmygridProperty(termdr,ProId)
			
		}
		
		//单击、双击树形术语条目
		ClickMygridtree=function(rowIndex,rowData){
			
			//属性内容可编辑
			proeditIndex = undefined;  //正在编辑的行index
		    prorowsvalue=undefined;   //正在编辑的行数据
			//ISPToolBarUse(true)
        	$("#TextSearchProperty").combobox('setValue', '');     //清空右侧检索框
        	termdr=rowData.MKBTRowId;
        	termdesc=rowData.MKBTDesc;
			$('#mygrid').treegrid('select',termdr);
        	RefreshSearchData("User.MKBTerm"+base,termdr,"A",termdesc)
        	/*$('#mygridProperty').datagrid('load',{ 
				ClassName:"web.DHCBL.MKB.MKBTermProperty",
				QueryName:"GetList",
				termdr: termdr	
			});
			$('#mygridProperty').datagrid('unselectAll');*/
			//是否显示图片
		 	IsShowImg(rowData)
			InitmygridProperty(termdr,"")
			/*//属性内容搜索框重新加载
			$('#TextSearchProperty').searchcombobox({ 
				url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+"User.MKBTermProperty"+termdr,
				onSelect:function () 
				{	
					$(this).combobox('textbox').focus();
					SearchProperty()
			        
		        }
			});*/
	
		}	  
 		/** *****************************************诊断树形模块******************************************************************************* */
	}
	else
	{	
		/** *****************************************诊断列表模块******************************************************************************* */
		document.getElementById("btnTreeCollapse").style.display = "none"; //隐藏树形全部折叠按钮
		document.getElementById("btnSwitchSortWay").style.display = ""; //显示切换排序按钮
		document.getElementById("ProLocDesc").style.display = ""; //显示专业科室检索框
		var locbasedr=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetIdByFlag","Loc")
		///根据输入的科室查询科室专业诊断
		$HUI.combotree('#ProLocDesc',{
			 url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmb&base="+locbasedr
			,onBeforeExpand:function(node){
				$(this).tree('expandFirstChildNodes',node)
	        },
	        placeholder:"请输入科室",
	        panelWidth:200,
	        panelHeight:200,
	        onSelect:function(node){
	         	$('#mygrid').datagrid('options').url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetMyLocList&TermId="+node.id+"&TBRowId="+locbasedr,
				$('#mygrid').datagrid('load');
				$('#mygrid').datagrid('unselectAll');
				termdr=""
				 //是否显示图片
		 	 	IsShowImg("")		  
	        },
			onShowPanel:function(){
				//$('#menuothers').menu('show')
			}
		});
		
		var sortway="knocount"
		SortWaytooltip="切换成原始排序"
		$HUI.tooltip('#btnSwitchSortWay',{
       		 content:SortWaytooltip,
       		 position: 'right', //top , right, bottom, left
				onShow: function(){
					$(this).tooltip('tip').css({
						'z-index':999999
					});
				}
    	});
		//切换排序按钮
		$("#btnSwitchSortWay").click(function (e) { 
				if (sortway=="knocount"){
					sortway="originseq"
					SortWaytooltip="切换成知识数量排序"
					$HUI.tooltip('#btnSwitchSortWay',{
		       		 content:SortWaytooltip,
		       		 position: 'right', //top , right, bottom, left
					 onShow: function(){
							$(this).tooltip('tip').css({
								'z-index':999999
							});
						}
		    		});
				}
				else
				{
					sortway="knocount"
					SortWaytooltip="切换成原始排序"
					$HUI.tooltip('#btnSwitchSortWay',{
		       		 content:SortWaytooltip,
		       		 position: 'right', //top , right, bottom, left
					onShow: function(){
							$(this).tooltip('tip').css({
								'z-index':999999
							});
					}
		    		});
				}
				ClearFunLib()
		 }) 
		
		//中心词新增按钮
		$("#btnAdd").click(function (e) { 
	
				AddData();
		 })  
		//术语维护查询框
		$('#TextSearch').searchcombobox({ 
			url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+"User.MKBTerm"+base,
			onSelect:function (record) 
			{	
				if ($(this).combobox('getText')=="...")
				{
					//数据超过11条,显示...，点击后辅助功能区 弹窗显示对应的所有数据 2020-05-29
					alert('辅助功能区显示所有数据，待做')
				}
				else
				{
					$(this).combobox('textbox').focus();
					TextSearchFun(record.ID);  
				}
		        
	        }
		});
		$('#TextSearch').combobox('textbox').bind('keyup',function(e){  
			if (e.keyCode==13){ 
				TextSearchFun("")  
			}
		}); 

		$("#btnSearch").click(function (e) { 
			TextSearchFun("");
		})
		
	    TextSearchFun = function(rowid) {
	    	  //科室下拉框赋空值
	    	  $('#ProLocDesc').combotree('setValue',"")
		      var desc=$('#TextSearch').combobox('getText')
		      //$('#mygrid').datagrid('options').url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetMyList&base="+base+"&desc="+desc, 
			  //$('#mygrid').datagrid('reload')
			  /*$('#mygrid').datagrid('load',{
			  		ClassName:"web.DHCBL.MKB.MKBTerm",         ///调用Query时
					QueryName:"GetList",
					'desc':desc,
					'base':base
				})*/
		      if ((CatDesc.indexOf("分级加载")!= -1)&(desc!==""))  //(basedesc=="全局化诊断词表")
		      {
		      	$('#mygrid').datagrid('options').url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=SearchTerm"
		      	$('#mygrid').datagrid('options').queryParams={'base':base,'desc':desc,'closeflag':closeflag,RowID:rowid}
		      }
		      else
		      {
		      	$('#mygrid').datagrid('options').url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetMyList&base="+base+"&sortway="+sortway
		      	$('#mygrid').datagrid('options').queryParams={'base':base,'desc':desc,'closeflag':closeflag,rowid:rowid}
		      }
		      	
				$('#mygrid').datagrid('load');
			   $('#mygrid').datagrid('unselectAll');
			
			  termdr=""
			 //是否显示图片
		 	 IsShowImg("")
	    }
		 
		 
		//中心词清屏按钮
		$("#btnRel").click(function (e) { 
	
				ClearFunLib();
		 })  
		 /*//中心词删除按钮
		$("#btnDel").click(function (e) { 
	
				DelData();
		 }) 
		 
		//中心词上移按钮
		$("#btnUp").click(function (e) { 
	
				OrderFunLib(1);
		 })  
		 
		//中心词下移按钮
		$("#btnDown").click(function (e) { 
	
				OrderFunLib(2);
		 }) 
		 //中心词移动到首行按钮
		$("#btnFirst").click(function (e) { 
	
				OrderFunLib(3);
		 }) 
		  //中心词置顶按钮
		$("#btnTop").click(function (e) { 
	
				TopData();
		 }) */
		 //术语条目详细信息按钮
		
		 //点击新增按钮
		AddData = function() {
			$("#myWin").show();
			var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-w-add',
				resizable:true,
				title:'新增',
				modal:true,
				//height:$(window).height()-70,
				buttonAlign : 'center',
				buttons:[{
					text:'保存',
					//iconCls:'icon-save',
					id:'save_btn',
					handler:function(){
						SaveFunLib("")
					}
				},{
					text:'关闭',
					//iconCls:'icon-cancel',
					handler:function(){
						myWin.close();
					}
				}]
			});	
			$('#form-save').form("clear");
		}
		
		 //点击修改按钮
		UpdateData=function () {
			var record = $("#mygrid").datagrid("getSelected"); 
			if (!(record))
			{	
				$.messager.alert('错误提示','请先选择一条记录!',"error");
				return;
			}
			var id=record.MKBTRowId
			$.cm({
				ClassName:"web.DHCBL.MKB.MKBTerm",
				MethodName:"OpenData",
				id:id
			},function(jsonData){
				$('#form-save').form("load",jsonData);	
				$("#myWin").show(); 
				var myWin = $HUI.dialog("#myWin",{
					iconCls:'icon-w-edit ',
					resizable:true,
					title:'修改',
					modal:true,
					//height:$(window).height()-70,
					buttons:[{
						text:'保存',
						//iconCls:'icon-save',
						id:'save_btn',
						handler:function(){
							SaveFunLib(id)
						}
					},{
						text:'关闭',
						//iconCls:'icon-cancel',
						handler:function(){
							myWin.close();
						}
					}]
				});
			});
			
		}
		///新增、更新
		SaveFunLib=function (id){	
			if ((basedesc=="疾病")||(basedesc=="检查")||(basedesc=="检验")||(basedesc=="手术"))
			{
				if (($('#MKBTDesc').combobox('getText')=="")||($('#MKBTDesc').combobox('getText')=="undefined"))
				{
					$.messager.alert('错误提示', '中心词不能为空!', "error");
					return;
				}
			}
			else
			{
				if ($.trim($("#MKBTDesc").val())=="")
				{
					$.messager.alert('错误提示','中心词不能为空!',"error");
					return;
				}
			}
			$('#form-save').form('submit', { 
				url: SAVE_ACTION_URL, 
				onSubmit: function(param){
					param.MKBTRowId = id;
					param.MKBTBaseDR = base;		
				},
				success: function (data) { 
					  var data=eval('('+data+')'); 
					  if (data.success == 'true') {
					  		$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
							/*$.messager.show({ 
							  title: '提示消息', 
							  msg: '提交成功', 
							  showType: 'show', 
							  timeout: 1000, 
							  style: { 
								right: '', 
								bottom: ''
							  } 
							}); */
							if (id!="")
							{
								$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
							}
							else{
								
								$.cm({
									ClassName:"web.DHCBL.MKB.MKBTerm",         ///调用Query时
									QueryName:"GetList",
									'base':base,
									 rowid: data.id   
								},function(jsonData){
									$('#mygrid').datagrid('insertRow',{
									index:0,
									row:jsonData.rows[0]
									})
								})
							}
							$('#myWin').dialog('close'); // close a dialog
					  } 
					  else { 
							var errorMsg ="提交失败！"
							if (data.errorinfo) {
								errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
							}
							$.messager.alert('操作提示',errorMsg,"error");
			
					}
	
				} 
			});
		}
		//术语名失去焦点自动生成检索码
		$('#MKBTDesc').bind('blur',function(){
			if ((basedesc=="疾病")||(basedesc=="检查")||(basedesc=="检验")||(basedesc=="手术"))
			{
				var MKBTDesc=$('#MKBTDesc').combobox('getValue')
			}
			else
			{
				var MKBTDesc=$('#MKBTDesc').val()
			}
	           $("#MKBTPYCode").val(Pinyin.GetJPU(MKBTDesc))
	      });
		///删除
		DelData=function (){                  
			var record = $("#mygrid").datagrid("getSelected"); 
			if (!(record))
			{	$.messager.alert('错误提示','请先选择一条记录!',"error");
				return;
			}
			if(record.TopDataFlag=="top"){
				for (var i=0;i<topdata.length;i++)
				{
					if (topdata[i].MKBTRowId==record.MKBTRowId)
					{
						topdata.splice(i,1)
					}
				}
			}
			$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
				if (r){	
					$.ajax({
						url:DELETE_ACTION_URL,  
						data:{
							"id":record.MKBTRowId      ///rowid
						},  
						type:"POST",   
						success: function(data){
								  var data=eval('('+data+')'); 
								  if (data.success == 'true') {
								  		$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
										/*$.messager.show({ 
										  title: '提示消息', 
										  msg: '删除成功', 
										  showType: 'show', 
										  timeout: 1000, 
										  style: { 
											right: '', 
											bottom: ''
										  } 
										});*/ 
										RefreshSearchData("User.MKBTerm"+base,record.MKBTRowId,"D","")
										$('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
										$('#mygrid').datagrid('unselectAll');  // 清空列表选中数据
										//ClearFunLib();  //调用清屏方法
								  } 
								  else { 
								  	var errorMsg =""
									if (data.info) {																
										if (data.info.indexOf("引用")!=-1)
										{
											/*errorMsg =data.info+ '<br/><font style="color:red;">确定要删除该数据及所有引用数据吗？</font>'
											$.messager.confirm('提示', errorMsg, function(r){
												if (r){
													DelReferData(record.MKBTRowId)
												}
											});*/
											ReferedList(record.MKBTRowId)
										}
										else
										{
											var errorMsg ="删除失败！"
											if (data.info) {
												errorMsg =errorMsg+ '<br/>错误信息:' + data.info
											}
											$.messager.alert('操作提示',errorMsg,"error");
										}
									}
								}			
						}  
					})
				}
			})		
		}
		/*///删除引用数据
	DelReferData=function(referID)
	{        
		if (referID=="")
		{
			return
		}

		var data=tkMakeServerCall('web.DHCBL.MKB.MKBTerm','DeleteDataAndRefer',referID);
		  var data=eval('('+data+')'); 
		  if (data.success == 'true') {
		  	    $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
				$('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
				$('#mygrid').datagrid('unselectAll');  // 清空列表选中数据
		  } 
		  else { 
				var errorMsg ="删除失败！"
				if (data.info) {
					errorMsg =errorMsg+ '<br/>错误信息:' + data.info
				}
				$.messager.alert('操作提示',errorMsg,"error");
	
	
		}					

	}*/
	///封闭
	CloseTerm=function (){
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		if(record.TopDataFlag=="top"){
			for (var i=0;i<topdata.length;i++)
			{
				if (topdata[i].MKBTRowId==record.MKBTRowId)
				{
					topdata.splice(i,1)
				}
			}
		}
		$.messager.confirm('提示', '确定要封闭所选的数据吗?', function(r){
			if (r){	
				$.ajax({
					url:CLOSE_ACTION_URL,  
					data:{
						"id":record.MKBTRowId      ///rowid
					},  
					type:"POST",   
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
							  		$.messager.popover({msg: '封闭成功！',type:'success',timeout: 1000});
									//ClearFunLib();  //调用清屏方法
							  		$('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
									$('#mygrid').datagrid('unselectAll');  // 清空列表选中数据
							  } 
							  else { 
									var errorMsg ="封闭失败！"
									if (data.info) {
										errorMsg =errorMsg+ '<br/>错误信息:' + data.info
									}
									$.messager.alert('操作提示',errorMsg,"error");
					
							}			
					}  
				})
			}
		})		
	}
	///解除封闭
	CancelCloseTerm=function (){
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		if(record.TopDataFlag=="top"){
			for (var i=0;i<topdata.length;i++)
			{
				if (topdata[i].MKBTRowId==record.MKBTRowId)
				{
					topdata.splice(i,1)
				}
			}
		}
		$.messager.confirm('提示', '确定要解除封闭所选的数据吗?', function(r){
			if (r){	
				$.ajax({
					url:CANCELCLOSE_ACTION_URL,  
					data:{
						"id":record.MKBTRowId      ///rowid
					},  
					type:"POST",   
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
							  		$.messager.popover({msg: '解除封闭成功！',type:'success',timeout: 1000});
									//ClearFunLib();  //调用清屏方法
							  		$('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
									$('#mygrid').datagrid('unselectAll');  // 清空列表选中数据
							  } 
							  else { 
									var errorMsg ="解除封闭失败！"
									if (data.info) {
										errorMsg =errorMsg+ '<br/>错误信息:' + data.info
									}
									$.messager.alert('操作提示',errorMsg,"error");
					
							}			
					}  
				})
			}
		})		
	}	

		/*SearchFunLib=function (){
			//var rows = $('#mygrid').datagrid('getRows');//获得所有行
	        // var row = rows[0];//根据index获得其中一行。
			var desc=$.trim($("#TextSearch").combobox('getText'));
			$('#mygrid').datagrid('load',{ 
					ClassName:"web.DHCBL.MKB.MKBTerm",
					QueryName:"GetList",
					'desc':desc,
					'base':base
				})
			$('#mygrid').datagrid('unselectAll');
			
			termdr=""
			//清空中间属性列表，变为图片，改变标题
			$('#mylayoutproperty').panel('setTitle','属性维护')
			if (document.getElementById('mygridProperty').style.display=="")   //如果是mygrid加载的状态
			{	
				$('#mygridProperty').datagrid('loadData', { total: 0, rows: [] }); 
				$('#mygridProperty').datagrid('unselectAll');
				document.getElementById('mygridProperty').style.display='none';  //隐藏mygrid
				$("#div-img").show();  //展示初始图片			
			}
			
			ISPToolBarUse(false)
			ClearProperty();
		}*/
		//清屏方法
		ClearFunLib=function (){
			 //科室下拉框赋空值
	    	  $('#ProLocDesc').combotree('setValue',"")
			//加载全部与否的标志
			closeflag=""
			TermID=""
			$("#TextSearch").combobox('setValue', '');
			$('#mygrid').datagrid('options').url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetMyList" //&base="+base+"&sortway="+sortway, 
			$('#mygrid').datagrid('load',  {
				'base':base,
				'desc':"",
				'sortway':sortway,
				'closeflag':""
			});
			$('#mygrid').datagrid('unselectAll');
			termdr=""
			//是否显示图片
		 	IsShowImg("")
			
			//ISPToolBarUse(false)			
			
		
			
		}
		
		
		///上移、下移、移动到首行
		OrderFunLib=function (type){  
			//更新
			var row = $("#mygrid").datagrid("getSelected"); 
			if (!(row))
			{
				$.messager.alert('错误提示','请先选择一条记录!',"error");
				return;
			}	   
			var index = $("#mygrid").datagrid('getRowIndex', row);	
			
			mysort(index, type, "mygrid")
			
			//遍历列表
			var order=""
			var rows = $('#mygrid').datagrid('getRows');
			var Sequence=parseInt(rows[0].MKBTSequence)
			for(var i=0; i<rows.length; i++){	
				var id =rows[i].MKBTRowId; //频率id
				var  seq=rows[i].MKBTSequence; //顺序
				if (parseInt(seq)<Sequence)
				{
				 	Sequence=parseInt(seq)
				}
				if (order!=""){
					order = order+"^"+id
				}else{
					order = id
				}
				
			}
			//获取级别默认值
			$.m({
				ClassName:"web.DHCBL.MKB.MKBTerm",
				MethodName:"SaveDragOrder",
				order:order,
				seq:Sequence
				},function(txtData){
				//alert(order+txtData)
				});
		}
		mysort=function (index, type, gridname) {
			if (1 == type) {
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
			else if (2 == type) {
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
			else { //移动到首行
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
		
		///置顶
		var topdata=new Array();
		TopData=function (){                  
			var record = $("#mygrid").datagrid("getSelected");
			if (!(record))
			{	$.messager.alert('错误提示','请先选择一条记录!',"error");
				return;
			}else{
				if(record.TopDataFlag=="top"){
					$.messager.alert('错误提示','已经是置顶数据!',"error");
					return;
				}else{
					$('#mygrid').datagrid('insertRow',{
						index: 0, // index start with 0
						row: {
						MKBTRowId: record.MKBTRowId, //record.MKBTDesc
						MKBTDesc: record.MKBTDesc+"<img src='../scripts/bdp/Framework/icons/mkb/nail.png' ></img>",
						MKBTPYCode:record.MKBTPYCode,
						MKBTNote:record.MKBTNote,
						MKBTDetailCount:record.MKBTDetailCount,
						TopDataFlag:"top"
						}
					});
					record.TopDataFlag="top"
					topdata.push(record)
					//alert(topdata.length)
					var rowIndex = $('#mygrid').datagrid('getRowIndex', record);
					$('#mygrid').datagrid('deleteRow', rowIndex);
					$('#mygrid').datagrid('freezeRow',0);
				}
			}
		}
		///取消置顶
		CancelTopData=function (){                  
			var record = $("#mygrid").datagrid("getSelected");
			if (!(record))
			{	$.messager.alert('错误提示','请先选择一条记录!',"error");
				return;
			}else{
				for (var i=0;i<topdata.length;i++)
				{
					if (topdata[i].MKBTRowId==record.MKBTRowId)
					{
						topdata.splice(i,1)
					}
				}
				ClearFunLib();
			}
		}

		/** 复制选中术语 */
		CopyTerm = function() {
				var record = $("#mygrid").datagrid("getSelected"); 
				if (!(record)) {
					$.messager.alert('提示','请选择复制的知识!',"warning");
					return;
				} else {
						termdr = record.MKBTRowId;
						var prodesc = record.MKBTDesc;
						$("#myWinCopyTerm").show(); 
						var myWinCopyTerm = $HUI.dialog("#myWinCopyTerm",{
							iconCls:'icon-w-paper',
							resizable:true,
							title:'复制'+prodesc,
							modal:true,
							//height:$(window).height()-70,
							buttonAlign : 'center',
							buttons:[{
								text:'复制格式',
								//iconCls:'icon-save',
								//id:'save_btn_CopyTermForm',
								handler:function(){
									if ($.trim($("#CopyMKBTDesc").val())=="")
									{
										$.messager.alert('错误提示','中心词不能为空!',"error");
										return;
									}
									$('#form-save-CopyTerm').form('submit', { 
											url: COPY_TERM_URL, 
											onSubmit: function(param){
												param.copytermdr = termdr,
												param.copyall = ""
											},
											success: function (data) { 
											  var data=eval('('+data+')'); 
											  if (data.success == 'true') {
											  	$.messager.popover({msg: '复制格式成功！',type:'success',timeout: 1000});
												/*$.messager.show({ 
												  title: '提示消息', 
												  msg: '复制格式成功', 
												  showType: 'show', 
												  timeout: 1000, 
												  style: { 
													right: '', 
													bottom: ''
												  } 
												}); */
												$.cm({
														ClassName:"web.DHCBL.MKB.MKBTerm",         ///调用Query时
														QueryName:"GetList",
														'base':base,
														 rowid: data.id   
													},function(jsonData){
														$('#mygrid').datagrid('insertRow',{
														index:0,
														row:jsonData.rows[0]
														})
													})
												ClearProperty();  // 重新载入当前页面数据  
											  } 
											  else { 
												var errorMsg ="更新失败！"
												if (data.errorinfo) {
													errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
												}
												 $.messager.alert('操作提示',errorMsg,"error");
									
											}
	
										} 
		  							}); 
									myWinCopyTerm.close();
								}
							},{
								text:'完全复制',
								//iconCls:'icon-save',
								handler:function(){
									if ($.trim($("#CopyMKBTDesc").val())=="")
									{
										$.messager.alert('错误提示','中心词不能为空!',"error");
										return;
									}
									$('#form-save-CopyTerm').form('submit', { 
											url: COPY_TERM_URL, 
											onSubmit: function(param){
												param.copytermdr = termdr,
												param.copyall = "1"
											},
											success: function (data) { 
											  var data=eval('('+data+')'); 
											  if (data.success == 'true') {
											  	$.messager.popover({msg: '完全复制成功！',type:'success',timeout: 1000});
												/*$.messager.show({ 
												  title: '提示消息', 
												  msg: '完全复制成功', 
												  showType: 'show', 
												  timeout: 1000, 
												  style: { 
													right: '', 
													bottom: ''
												  } 
												}); */
												$.cm({
														ClassName:"web.DHCBL.MKB.MKBTerm",         ///调用Query时
														QueryName:"GetList",
														'base':base,
														 rowid: data.id   
													},function(jsonData){
														$('#mygrid').datagrid('insertRow',{
														index:0,
														row:jsonData.rows[0]
														})
													})
												ClearProperty();  // 重新载入当前页面数据  
											  } 
											  else { 
												var errorMsg ="更新失败！"
												if (data.errorinfo) {
													errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
												}
												 $.messager.alert('操作提示',errorMsg,"error");
									
											}
	
										} 
		  							}); 
									myWinCopyTerm.close();
								}
							}]
						});	
						$('#form-save-CopyTerm').form("clear");
				}
		}
		
		///左侧列表
		var columns =[[  
					  {field:'MKBTRowId',title:'RowId',width:80,sortable:true,hidden:true},
					  {field:'MKBTCode',title:'代码',width:120,sortable:true,hidden:true},
					  {field:'MKBTDesc',title:'中心词',width:270,sortable:true,
					  	formatter: function(value,row,index){
					  			return value+"<span class='badgeDiv'>"+parseInt(row.MKBTDetailCount)+"</span>";
					  	},
					  	styler: function (value, row, index) {
					  		if(row.MKBTActiveFlag=="N")
					  		{
								 return 'background-color:red;';
					  		} 
				           }
					  },
					  {field:'MKBTSequence',title:'顺序',width:60,sortable:true,/*sorter:function (a,b){  
						    if(a.length > b.length) return 1;
						        else if(a.length < b.length) return -1;
						        else if(a > b) return 1;
						        else return -1;
						},*/hidden:true },
					  {field:'MKBTPYCode',title:'拼音码',width:80,hidden:true},
					  {field:'MKBTNote',title:'备注',width:80,hidden:true},
					  {field:'MKBTDetailCount',title:'知识数量',width:80,hidden:true},
					  {field:'MKBTActiveFlag',title:'是否封闭',width:80,hidden:true},
					  {field:'TopDataFlag',title:'TopDataFlag',width:80,hidden:true}
					  ]];
		 //如果有配置属性，则自动生成列
		if (extendChild!="")  
		{
			var colsField = extendChild.split("[N]"); 
			var colsHead = extendTitle.split("[N]"); 
			for (var i = 0; i <colsField.length; i++) {
				var fieldid=colsField[i];
				var labelName=colsHead[i];  //标题
				var comId='Extend'+colsField[i];   //控件id				
				//添加列 方法2
				var column={};  
				column["title"]=labelName;  
				column["field"]=comId;  
				column["width"]=150;  
				column["sortable"]=false; 
				//column["hidden"]=true; 
				columns[0].push(column)
			
			}
		}
		var mygrid = $HUI.datagrid("#mygrid",{
			url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetMyList&base="+base+"&rowid="+TermID+"&sortway="+sortway+"&closeflag="+closeflag,
			/*url:$URL,
			queryParams:{
				ClassName:"web.DHCBL.MKB.MKBTerm",         ///调用Query时
				QueryName:"GetList",
				'base':base,
				'rowid':TermID
			},*/
			ClassTableName:'User.MKBTerm'+base,
			SQLTableName:'MKB_Term',
			columns: columns,  //列信息
			pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
			pageSize:20,
			pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
			singleSelect:true,
			idField:'MKBTRowId', 
			rownumbers:false,    //设置为 true，则显示带有行号的列。
			fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
			//remoteSort:false,  //定义是否从服务器排序数据。true
			scrollbarSize :0,
			//sortName:'MKBTSequence',
			//sortOrder:'asc',
			onRowContextMenu: function(e, rowIndex, rowData){   //右键菜单
				var $clicked=$(e.target);
				//console.log($clicked)
				//copytext =$clicked.text()||$clicked.val()   //普通复制功能
				var htmltext=$clicked.html()
				copytext=htmltext.match(/(\S*)<span/)[1];  //去掉知识数量的数字
				
				termdr=rowData.MKBTRowId
				e.preventDefault();  //阻止浏览器捕获右键事件
				var record=$(this).datagrid("selectRow", rowIndex); //根据索引选中该行 
				//置顶、取消置顶是否可用
				var stickDisable=false,cancelstickDisable=false
				if (rowData.TopDataFlag=="top"){
					stickDisable=true
				}
				else
				{
					cancelstickDisable=true
				}
				//处理右键里的上移、下移、移动首行是否可用	
				var upDisable=false,downDisable=false
				if (rowIndex==0){
					upDisable=true
				}
				var rows = $('#mygrid').datagrid('getRows');
				if ((rowIndex+1)==rows.length){
					downDisable=true
				}
				//封闭、取消封闭是否可用
				var closetermDisable=false,cancelclosetermDisable=false
				if (rowData.MKBTActiveFlag=="N"){
					closetermDisable=true
				}
				else
				{
					cancelclosetermDisable=true
				}
				
				
				//添加右键规则管理菜单和文献预览菜单
	            var docMenuStr=""
	            var detailIdStr=termdr
				var docMenuInfos=tkMakeServerCall('web.DHCBL.MKB.MKBKLMappingDetail','CreateDocRightMenu',base,detailIdStr);
				if (docMenuInfos!="")
				{
					var docMenuInfo=docMenuInfos.split("[A]")
					for (var i = 0; i <docMenuInfo.length; i++) {
						var docMenu =docMenuInfo[i];  //右键菜单
						var docMenu=eval('(' + docMenu + ')');
						//alert(docMenu)
						docMenuStr=docMenuStr+'<div id='+docMenu.DocPath+' name="文献预览" iconCls="icon-apply-check" data-options="">'+docMenu.DocDesc+'</div>'			
					}
					docMenuStr='<div iconCls="icon-apply-check"><span>文献预览</span><div style="width:500px;">'+docMenuStr+'</div></div>'
				}
				
				var mygridmm = $('<div style="width:80px;"></div>').appendTo('body');	
				mygridmm.html('<div onclick="TopData()" iconCls="icon-stick" data-options="disabled:'+stickDisable+'" id="stick">置顶</div>'+
	        		'<div onclick="CancelTopData()" iconCls="icon-cancelstick" data-options="disabled:'+cancelstickDisable+'" id="cancelstick">取消置顶</div>'+
	        		'<div onclick="UpdateData()" iconCls="icon-write-order" data-options="">修改</div>'+
	        		'<div onclick="DelData()" iconCls="icon-cancel" data-options="">删除</div>'+
	        		'<div onclick="CloseTerm()" iconCls="icon-lockdata" data-options="disabled:'+closetermDisable+'" id="closeterm">封闭</div>'+
	        		'<div onclick="CancelCloseTerm()" iconCls="icon-unlock" data-options="disabled:'+cancelclosetermDisable+'" id="cancelcloseterm">解除封闭</div>'+
	        		'<div onclick="CopyText()"iconCls="icon-copyorder" data-options="">复制文本</div>'+
	        		'<div onclick="CopyTerm()" iconCls="icon-copyorder" data-options="">复制术语</div>'+
	        		'<div class="menu-sep"></div>'+
	        		'<div iconCls="icon-changeposition">'+
	        		'<span>位置移动</span>'+
	        			'<div style="width:80px;">'+
	        			'<div onclick="OrderFunLib(1)" iconCls="icon-shiftup" data-options="disabled:'+upDisable+'" id="shiftup">上移</div>'+
	        			'<div onclick="OrderFunLib(2)" iconCls="icon-shiftdown" data-options="disabled:'+downDisable+'" id="shiftdown">下移</div>'+
	        			'<div onclick="OrderFunLib(3)" iconCls="icon-shiftfirst" id="shiftfirst" data-options="disabled:'+upDisable+'">移到首行</div>'+
	        			'</div>'+
	        		'</div>'+
	        		'<div onclick="SeeTermVersion()" iconCls="icon-apply-check" data-options="">查看版本</div>' +
	       			'<div onclick="SeeTermChangeLog()" iconCls="icon-apply-check" data-options="">查看日志</div>' +
	        		'<div class="menu-sep"></div>'+
	        		'<div onclick="GuideImage()" iconCls="icon-productimage" data-options="">医为百科</div>'+
	        		menuStr+docMenuStr)
	        		//.appendTo(mygridmm).click(stopPropagation)  //右键菜单里 在IE8下点击右键菜单的按钮 ，没有执行点击事件，原因：append的onclick不会触发，用html的可以触发。
	        		.click(stopPropagation);
				mygridmm.menu({
				    onClick:function(item){
				    	var itemid=item.id
						if ((item.name=="规则管理")&(itemid!="")&(itemid!=null)&(itemid!=undefined)){	
							//var detailIdStr=termRowId+"-"+property+":"+rowData.MKBTPDRowId
							var newOpenUrl="../csp/dhc.bdp.mkb.mkbklmappingdetail.csp?mappingBase="+itemid+"&termBase="+base+"&detailIdStr="+detailIdStr
							//window.open(newOpenUrl, 'newwindow', 'height=600, width=1000, top=120, left=260, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no')				
							CheckMappingDetail(newOpenUrl)
						}
						if ((item.name=="文献预览")&(itemid!="")&(itemid!=null)&(itemid!=undefined)){	
							previewFile(itemid)
						}
				    }
				});
				/*if (rowData.TopDataFlag=="top"){
					$('#stick').attr('onclick', '').unbind('click').click( function () {  })
					$('#cancelstick').attr('onclick', '').unbind('click').click( function () { CancelTopData()  })
					$('#stick').css({ "cursor": "default", "opacity": "0.4" });
					$('#cancelstick').css({ "cursor": "pointer", "opacity": "1" });
				}
				else
				{
					$('#cancelstick').css({ "cursor": "default", "opacity": "0.4" });
					$('#stick').css({ "cursor": "pointer", "opacity": "1" });
					$('#stick').attr('onclick', '').unbind('click').click( function () {TopData()  })
					$('#cancelstick').attr('onclick', '').unbind('click').click( function () {   })
					
				}
				
				if(rowIndex==0){
					$('#shiftup').attr("disabled", "disabled").css({ "cursor": "default", "opacity": "0.4" });
					$('#shiftfirst').attr("disabled", "disabled").css({ "cursor": "default", "opacity": "0.4" });
				}else
				{
					$('#shiftup').removeAttr('disabled').css({ "cursor": "pointer", "opacity": "1" });
					$('#shiftfirst').removeAttr('disabled').css({ "cursor": "pointer", "opacity": "1" });
				}
				var rows = $('#mygrid').datagrid('getRows');
				if ((rowIndex+1)==rows.length){
					$('#shiftdown').attr("disabled", "disabled").css({ "cursor": "default", "opacity": "0.4" });
				}else
				{
					$('#shiftdown').removeAttr('disabled').css({ "cursor": "pointer", "opacity": "1" });
				}
				if (rowData.MKBTActiveFlag=="N"){
					var itemEl = $('#closeterm')[0];  // the menu item element
					mygridmm.menu('disableItem', itemEl);
					$('#cancelcloseterm').css('display','');
				}
				else
				{
					var itemEl = $('#closeterm')[0];  // the menu item element
					mygridmm.menu('enableItem', itemEl);	
					$('#cancelcloseterm').css('display','none');
				}
				*/
				mygridmm.menu('show',{
					left:e.pageX,  
					top:e.pageY
				});
				
				
				
			},
			/*onDblClickRow:function(rowIndex,rowData){
	        	UpdateData();
	        },*/
	        onDblClickRow: function (rowIndex,rowData) {
				ClickMygrid(rowIndex,rowData)
	        },
	         onClickRow: function (rowIndex,rowData) {
	         	ClickMygrid(rowIndex,rowData)
	        },
			onLoadSuccess:function(data) {
				$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
				//保存用户习惯
				$(this).datagrid('columnMoving');		
				//ISPToolBarUse(false) ///初始化属性工具条不可用
        		for(var i=0;i<topdata.length;i++){
        			var rowindex=$('#mygrid').datagrid('getRowIndex', topdata[i].MKBTRowId);
        			//alert(rowindex)
					if (rowindex>=0)
					{
						$('#mygrid').datagrid('deleteRow', rowindex);
					}
					$('#mygrid').datagrid('insertRow',{
						index: 0, // index start with 0
						row: {
							MKBTRowId:topdata[i].MKBTRowId, //record.MKBTDescFramework\icons\mkb
							MKBTDesc: topdata[i].MKBTDesc+"<img src='../scripts/bdp/Framework/icons/mkb/nail.png' ></img>",
							MKBTPYCode:topdata[i].MKBTPYCode,
							MKBTNote:topdata[i].MKBTNote,
							MKBTDetailCount:topdata[i].MKBTDetailCount,
							TopDataFlag:"top"
						}
					}),
					$('#mygrid').datagrid('freezeRow',0);
					
        	  }	
        	  //检索框不为空时，选中第一条
        	  var searchvalue=$('#TextSearch').combobox('getText');
        	   
        	   if((SaveProTermID=="")&((TermID!="")||(searchvalue!=""))){
	        	
				if (data.total!=0)
			 	{
					$('#mygrid').datagrid('selectRow',0);
					var rowData=$('#mygrid').datagrid('getSelected')
					if (rowData!=undefined)
					{
						//是否显示图片
		 				IsShowImg(rowData)
					
	        	  	//ISPToolBarUse(true)
		         		$("#TextSearchProperty").combobox('setValue', ''); 
	        	  	
	        	  		InitmygridProperty(termdr,ProId)
	        	  	/*$('#mygridProperty').datagrid('load',{ 
						ClassName:"web.DHCBL.MKB.MKBTermProperty",
						QueryName:"GetList",
						termdr: TermID,
						rowid:ProId	
					});
					$('#mygridProperty').datagrid('unselectAll');
					*/
					/*//术语维护查询框
					$('#TextSearchProperty').searchcombobox({ 
						url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+"User.MKBTermProperty"+termdr,
						onSelect:function () 
						{	
							$(this).combobox('textbox').focus();
							SearchProperty()
					        
				        }
					});*/
	        	  	}  
	        	  }
        	   }
			},
			
	        toolbar:'#mytbar'
		});
		/*///设置左侧列表的分页属性
		var mypagination = $('#mygrid').datagrid('getPager');
		   if (mypagination){
		       $(mypagination).pagination({
		       	  showPageList:false,
		       	  showRefresh: false,
				  displayMsg: ''
		       });
		   }*/
		   
		ShowUserHabit('mygrid');
		//标题
		$("#mygrid").datagrid("getPanel").panel("setTitle",basedesc)
		
		//单击、双击列表型术语条目
		ClickMygrid=function(rowIndex,rowData){
			//属性内容可编辑
			proeditIndex = undefined;  //正在编辑的行index
		    prorowsvalue=undefined;   //正在编辑的行数据
			//ISPToolBarUse(true)
         	$("#TextSearchProperty").combobox('setValue', '');     //清空右侧检索框
        	termdr=rowData.MKBTRowId;
        	termdesc=rowData.MKBTDesc;
        	//保存历史和频次记录
        	if (termdesc.indexOf("img"))
        	{
        		termdesc=termdesc.replace("<img src='../scripts/bdp/Framework/icons/mkb/nail.png' ></img>","")
        	}
        	RefreshSearchData("User.MKBTerm"+base,termdr,"A",termdesc)
        	//是否显示图片
		 	IsShowImg(rowData)
		 	
        	InitmygridProperty(termdr,"")
        	
			
			
			/*//术语维护查询框
			$('#TextSearchProperty').searchcombobox({ 
				url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+"User.MKBTermProperty"+termdr,
				onSelect:function () 
				{	
					$(this).combobox('textbox').focus();
					SearchProperty()
			        
		        }
			});*/
			
			
		}
		
		/** *****************************************诊断列表模块********************************************************************************** */
	}	

	
	
		/** *****************************************诊断属性模块***************************************************************************************** */
   
	    
    /*************************************************术语扩展属性维护开始*****************************************************/  
	 //类型
	$HUI.combobox("#MKBTEPType",{
		valueField:'value',
		textField:'text',
		data:[
			{value:'TX',text:'文本'},
			{value:'TA',text:'多行文本框'},
			{value:'R',text:'单选框'},
			{value:'CB',text:'复选框'},	
			{value:'C',text:'下拉框'},	
			{value:'S',text:'引用术语'},	
			{value:'SD',text:'知识表达式'},
			{value:'D',text:'日期'}			
		]
	});
	
	/**********************术语扩展属性配置项开始*******************/
	var extendproid=""
	//术语扩展属性配置项新增
	AddExtendProConfig=function(){
		if(indexExtendProConfig!==""){
	           $('#mygridExtendProConfig').datagrid('endEdit', indexExtendProConfig);
	        }
 		$('#mygridExtendProConfig').datagrid('appendRow',{  
		     ConfigName : "" 
		}) 
		var editIndex = $('#mygridExtendProConfig').datagrid('getRows').length - 1;
		indexExtendProConfig=editIndex
		$('#mygridExtendProConfig').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
		var editor = $('#mygridExtendProConfig').datagrid('getEditor', { index: editIndex, field: 'ConfigName' });
		if (editor) {
		    editor.target.focus();
		} else {
		    var editors = $('#mygridExtendProConfig').datagrid('getEditors', editIndex);
		    if (editors.length) {
		        editors[0].target.focus();
		    }
		}
	}
	//术语扩展属性配置项删除
	DelExtendProConfig=function(){
		var record = $("#mygridExtendProConfig").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}  else {
			   $.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
				if (r){	
					var index=$('#mygridExtendProConfig').datagrid('getRowIndex',record);
			   		if ((record.ConfigNum!="")&(record.ConfigNum!="undefined")&(record.ConfigNum!=undefined)) //后台删除
				   	{
						var saveFlag =tkMakeServerCall("web.DHCBL.MKB.MKBTermExtendPro","DeleteConfig",extendproid,index);
						if(saveFlag=="true")
						{
							$.messager.alert('提示','删除成功!',"info");
							//$('#mygridExtendProConfig').datagrid('reload');
						}
						else
						{
							$.messager.alert('错误提示',saveFlag,"error");
						}
				   	}
				   	$('#mygridExtendProConfig').datagrid('deleteRow',index);
				   	$('#mygridExtendProConfig').datagrid('clearSelections'); 
			 	}
			});
        }
	}
	//术语扩展属性清除配置项配置
	RemoveExtendConfigTool=function(){
		if ($("#trextendconfig").length>0){
			$("#trextendconfig").remove();
		}
		if ($("#trextendconfiggrid").length>0){
			$("#trextendconfiggrid").remove();
		}
	}
	//术语扩展属性新增配置项配置
	AppendExtendConfigTool=function(type,extendproid,configJson){
		//引用术语配置项
		if (type=="S"){
			var configTool="<tr id='trextendconfig'><td class='tdlabel'><font color=red>*</font>配置项</td><td><input id='ExtendProConfig' name='ExtendProConfig' type='text' class='hisui-combobox'  style='width:204px' data-options='required:true'></td></tr>"
			var targetConfig = $(configTool).appendTo("#form-save-ExtendPro table");
			$.parser.parse(targetConfig);
			$("#ExtendProConfig").combobox({
				url:$URL+"?ClassName=web.DHCBL.MKB.MKBTermBase&QueryName=GetDataForCmb1&ResultSetType=array",
				valueField:'MKBTBRowId',
				textField:'MKBTBDesc',
				mode:'remote'
			});
		}
		//知识表达式配置项
		else if(type=="SD"){
			var configTool="<tr id='trextendconfig'><td class='tdlabel'><font color=red>*</font>配置项</td><td><input id='ExtendProConfig' name='ExtendProConfig' type='text' class='hisui-combobox'  style='width:204px' data-options='required:true'></td></tr>"
			var targetConfig = $(configTool).appendTo("#form-save-ExtendPro table");
			$.parser.parse(targetConfig);
			$("#ExtendProConfig").combobox({
				url:$URL+"?ClassName=web.DHCBL.MKB.MKBTermBase&QueryName=GetDataForCmb1&ResultSetType=array",
				valueField:'MKBTBRowId',
				textField:'MKBTBDesc',
				mode:'remote'
			});
		}
		//单选框、复选框或下拉框配置项
		else if ((type=="R")||(type=="CB")||(type=="C")){
			var targetConfigGrid=$("<tr id='trextendconfiggrid'><td colspan='2' style='padding:4px 0 0 10px'><div id='mygridExtendProConfig' style='width:250px;height:270px;'></div></td></tr>").appendTo("#form-save-ExtendPro table");
			$.parser.parse(targetConfigGrid);
			//术语扩展属性可编辑配置项列表
			$("#mygridExtendProConfig").datagrid({
				/*url:$URL,
				queryParams:{
					ClassName:"web.DHCBL.MKB.MKBTermExtendPro",         ///调用Query时
					QueryName:"GetConfigList",
					'rowid': extendproid
				},*/
				columns: [[  
				  {field:'ConfigNum',title:'ConfigNum',width:150,sortable:true,hidden:true},
				  {field:'ConfigName',title:'配置项名称',width:150,sortable:true,editor:{type:'validatebox'}}
				  ]],  //列信息
				pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
				pageSize:20,
				pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
				singleSelect:true,
				idField:'ConfigName', 
				rownumbers:true,    //设置为 true，则显示带有行号的列。
				fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
				remoteSort:false,  //定义是否从服务器排序数据。true
				toolbar:[{
					iconCls:'icon-add',
					text:'新增',
					id:'add_btn_ExtendProConfig',
					handler:AddExtendProConfig  
				},{
					iconCls:'icon-cancel',
					text:'删除',
					id:'del_btn_ExtendProConfig',
					handler:DelExtendProConfig
				}],
				onClickRow:function(rowIndex,rowData){
					$("#ExtendProConfig").val(rowData.ConfigName);

				},
				 onClickCell:function(index, field, value){
			        if(indexExtendProConfig!==""){
			           $(this).datagrid('endEdit', indexExtendProConfig);
			        }
			        $(this).datagrid('beginEdit', index);
			        $(this).datagrid('selectRow', index);
			        indexExtendProConfig=index;
			      },
			      onAfterEdit:function(index, row, changes){
			        	if (row.ConfigName==""){
			        		$.messager.alert('错误提示','配置项名称不能为空!',"error");
			        		$('#mygridExtendProConfig').datagrid('deleteRow',index);
			        		return;
			        	}else{
			        		var record = $("#mygridExtendProConfig").datagrid("getSelected"); 
				        	var existFlag="";
				        	var dataConfig = $('#mygridExtendProConfig').datagrid('getRows');   
						    for(var i =0; i< dataConfig.length;i++){  
						    	if ((row.ConfigName==dataConfig[i].ConfigName)&(record!=dataConfig[i])){
							    	existFlag="Y";		    		
							    }	
						    }  
						    if (existFlag=="Y")
							 {
							 	$.messager.alert('错误提示','该配置项已存在!',"error");
							 	$('#mygridExtendProConfig').datagrid('deleteRow',index);
								return;
							 }
			        	}
			      }
			});
			if ((configJson!="")&(configJson!=undefined)){ //未保存后台配置项数据加载
				var data = $.parseJSON(configJson);  
				$('#mygridExtendProConfig').datagrid('loadData', data); //将数据绑定到datagrid  
			}else{ //已保存后台配置项数据加载
				$('#mygridExtendProConfig').datagrid({   
				    url:$URL,
					queryParams:{
						ClassName:"web.DHCBL.MKB.MKBTermExtendPro",         ///调用Query时
						QueryName:"GetConfigList",
						'rowid': extendproid
					}
				}); 
			}
		}
	}
	$("#MKBTEPType").combobox({
		onSelect:function(record){
			RemoveExtendConfigTool();
			AppendExtendConfigTool(record.value);
		}
	});
	/**********************术语扩展属性配置项结束**********************/
	//术语扩展属性新增
	/*AddExtendPro=function(){
		if(indexExtendProConfig!==""){
	           $("#mygridExtendProConfig").datagrid('endEdit', indexExtendProConfig);
	        }
		var extendproName=$.trim($("#MKBTEPName").val());
		if (extendproName=="")
		{
			$.messager.alert('错误提示','扩展属性名称不能为空!',"error");
			return;
		}
		if (($('#MKBTEPType').combobox('getValue')=="")||($('#MKBTEPType').combobox('getValue')=="undefined"))
		{
			$.messager.alert('错误提示','类型不能为空!',"error");
			return;
		}
	    //术语扩展属性配置项赋值
		var configstr=""
		if (($('#MKBTEPType').combobox('getValue')=="S")||($('#MKBTEPType').combobox('getValue')=="SD")){
			configstr=$('#ExtendProConfig').combobox('getValue');
		}
		if (($('#MKBTEPType').combobox('getValue')=="R")||($('#MKBTEPType').combobox('getValue')=="CB")||($('#MKBTEPType').combobox('getValue')=="C")){
			var dataExtendConfig = $('#mygridExtendProConfig').datagrid('getRows');  
		    for(var i =0; i< dataExtendConfig.length;i++){ 
		    	if (configstr==""){
					configstr=dataExtendConfig[i].ConfigName
				}else{
					configstr=configstr+"&%"+dataExtendConfig[i].ConfigName
				}
		    }  
		    if (configstr==""){
		    	$.messager.alert('错误提示','配置项不能为空!',"error");
  				return;
		    }
		}
		
		var parref=propertyresid;
		if(parref==""){
			parref=propertyid
		}
		$('#form-save-ExtendPro').form('submit', { 
			url: EXTENDPRO_SAVE_ACTION_URL, 
			onSubmit: function(param){
				param.MKBTEPParRef = parref;
				param.MKBTEPRowId = "";
				param.MKBTEPConfig = configstr;
			},
			success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
						$.messager.show({ 
						  title: '提示消息', 
						  msg: '提交成功', 
						  showType: 'show', 
						  timeout: 1000, 
						  style: { 
							right: '', 
							bottom: ''
						  } 
						}); 
						$('#mygridExtendPro').datagrid('reload');  // 重新载入当前页面数据 
				  } 
				  else { 
						var errorMsg ="提交失败！"
						if (data.errorinfo) {
							errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
						}
						$.messager.alert('操作提示',errorMsg,"error");
				}

			} 
		});
		RemoveExtendConfigTool();
	 	$('#form-save-ExtendPro').form("clear");
		$("#MKBTEPType").combobox('setValue','TX');
	}*/
	//术语扩展属性修改
	/*UpdateExtendPro=function(){
		if(indexExtendProConfig!==""){
	           $("#mygridExtendProConfig").datagrid('endEdit', indexExtendProConfig);
	        }
		var record = $("#mygridExtendPro").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}  else {             
        	var extendproName=$.trim($("#MKBTEPName").val());
			if (extendproName=="")
			{
				$.messager.alert('错误提示','扩展属性名称不能为空!',"error");
				return;
			}
        	if (($('#MKBTEPType').combobox('getValue')=="")||($('#MKBTEPType').combobox('getValue')=="undefined"))
			{
				$.messager.alert('错误提示','类型不能为空!',"error");
				return;
			}
			 //术语扩展属性配置项赋值
			var configstr=""
			if (($('#MKBTEPType').combobox('getValue')=="S")||($('#MKBTEPType').combobox('getValue')=="SD")){
				configstr=$('#ExtendProConfig').combobox('getValue');
			}
			if (($('#MKBTEPType').combobox('getValue')=="R")||($('#MKBTEPType').combobox('getValue')=="CB")||($('#MKBTEPType').combobox('getValue')=="C")){
				var dataExtendConfig = $('#mygridExtendProConfig').datagrid('getRows');  
			    for(var i =0; i< dataExtendConfig.length;i++){  
			    	if (configstr==""){
						configstr=dataExtendConfig[i].ConfigName
					}else{
						configstr=configstr+"&%"+dataExtendConfig[i].ConfigName
					}
			    }  
			    if (configstr==""){
			    	$.messager.alert('错误提示','配置项不能为空!',"error");
	  				return;
			    }
			}
			var parref=propertyresid;
			if(parref==""){
				parref=propertyid
			}
			$('#form-save-ExtendPro').form('submit', { 
				url: EXTENDPRO_SAVE_ACTION_URL, 
				onSubmit: function(param){
					param.MKBTEPParRef = parref;
					param.MKBTEPRowId = extendproid;
					param.MKBTEPConfig = configstr;
				},
				success: function (data) { 
					  var data=eval('('+data+')'); 
					  if (data.success == 'true') {
							$.messager.show({ 
							  title: '提示消息', 
							  msg: '提交成功', 
							  showType: 'show', 
							  timeout: 1000, 
							  style: { 
								right: '', 
								bottom: ''
							  } 
							}); 
							$('#mygridExtendPro').datagrid('reload');  // 重新载入当前页面数据 
					  } 
					  else { 
							var errorMsg ="提交失败！"
							if (data.errorinfo) {
								errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
							}
							$.messager.alert('操作提示',errorMsg,"error");
					}
	
				} 
			});
    	 	RemoveExtendConfigTool();
		 	$('#form-save-ExtendPro').form("clear");
			$("#MKBTEPType").combobox('setValue','TX');
        }
	}*/
	
	//术语扩展属性重置按钮
	$("#refresh_btn_ExtendPro").click(function (e) { 
		RefreshExtendPro();
	 }) 
	//术语扩展属性新增按钮
	 $("#add_btn_ExtendPro").click(function (e) { 
		AddExtendPro();
	 }) 
	 //术语扩展属性修改按钮
	 $("#update_btn_ExtendPro").click(function (e) { 
		UpdateExtendPro();
	 }) 
	//术语扩展属性重置表单
	 RefreshExtendPro=function(){
	 	RemoveExtendConfigTool();
	 	$('#form-save-ExtendPro').form("clear");
		$("#MKBTEPType").combobox('setValue','TX');
	   	$('#mygridExtendPro').datagrid('clearSelections');
	 }
	  //术语扩展属性新增
	 
	 var k 
	AddExtendPro=function(){
		if(indexExtendProConfig!==""){
           $("#mygridExtendProConfig").datagrid('endEdit', indexExtendProConfig);
        }
        var extendproname=$.trim($("#MKBTEPName").val())
		if (extendproname=="")
		{
			$.messager.alert('错误提示','扩展属性名称不能为空!',"error");
			return;
		}
		//新增时扩展属性的重复校验
		var rows = $("#mygridExtendPro").datagrid("getRows"); //获取当前页的所有行
		for(var i=0;i<rows.length;i++)
		{
			if (rows[i].MKBTEPName==extendproname){
				$.messager.alert('错误提示','该记录已存在!',"error");
				return;
			}
		}
    	if (($('#MKBTEPType').combobox('getValue')=="")||($('#MKBTEPType').combobox('getValue')=="undefined"))
		{
			$.messager.alert('错误提示','类型不能为空!',"error");
			return;
		}
		 //术语扩展属性配置项赋值
		var configstr=""
		if (($('#MKBTEPType').combobox('getValue')=="S")||($('#MKBTEPType').combobox('getValue')=="SD")){
			configstr=$('#ExtendProConfig').combobox('getValue');
			if (configstr==""){
		    	$.messager.alert('错误提示','配置项不能为空!',"error");
  				return;
		    }
		}
		if (($('#MKBTEPType').combobox('getValue')=="R")||($('#MKBTEPType').combobox('getValue')=="CB")||($('#MKBTEPType').combobox('getValue')=="C")){
			var dataExtendConfig = $('#mygridExtendProConfig').datagrid('getRows');  
			var configrows="";
		    var j=0;
		    for(var i =0; i< dataExtendConfig.length;i++){  
		    	if ($.trim(dataExtendConfig[i].ConfigName)!=""){
			    	j=j+1;
			    	if (configstr==""){
						configstr=dataExtendConfig[i].ConfigName
						configrows='{"ConfigName":"'+dataExtendConfig[i].ConfigName+'"}'
					}else{
						configstr=configstr+"&%"+dataExtendConfig[i].ConfigName
						configrows=configrows+',{"ConfigName":"'+dataExtendConfig[i].ConfigName+'"}'
					}
		    	}
		    }  
		    var configJson='{"total":'+j+',"rows":['+configrows+']}'
		    if (configstr==""){
		    	$.messager.alert('错误提示','配置项不能为空!',"error");
  				return;
		    }
		}
		
		k=k+1;
		
		$('#mygridExtendPro').datagrid('appendRow',{  
		     MKBTEPName : extendproname ,
		     MKBTEPType : $('#MKBTEPType').combobox('getValue'),
		     MKBTEPConfig: configstr,
		     Id:k,
		     configJson:configJson
		}) 
		changeUpDownStatusEP();
		RefreshExtendPro();
	}
	//术语扩展属性修改
	UpdateExtendPro=function(){
		var record = $("#mygridExtendPro").datagrid("getSelected")
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		if(indexExtendProConfig!==""){
           $("#mygridExtendProConfig").datagrid('endEdit', indexExtendProConfig);
        }
        var extendproname=$.trim($("#MKBTEPName").val())
		if (extendproname=="")
		{
			$.messager.alert('错误提示','扩展属性名称不能为空!',"error");
			return;
		}
		//修改时扩展属性的重复校验
		var rows = $("#mygridExtendPro").datagrid("getRows"); //获取当前页的所有行
		var selectId=record.Id;
		var selectExtendRowId=record.MKBTEPRowId;
		for(var i=0;i<rows.length;i++)
		{
			if((selectId!="")&&(selectId!=undefined)){if(selectId==rows[i].Id) continue;}
			if((selectExtendRowId!="")&&(selectExtendRowId!=undefined)){if(selectExtendRowId==rows[i].MKBTEPRowId) continue;}
			if (rows[i].MKBTEPName==extendproname){
				$.messager.alert('错误提示','该记录已存在!',"error");
				return;
			}
		}
    	if (($('#MKBTEPType').combobox('getValue')=="")||($('#MKBTEPType').combobox('getValue')=="undefined"))
		{
			$.messager.alert('错误提示','类型不能为空!',"error");
			return;
		}
		 //术语扩展属性配置项赋值
		var configstr=""
		if (($('#MKBTEPType').combobox('getValue')=="S")||($('#MKBTEPType').combobox('getValue')=="SD")){
			configstr=$('#ExtendProConfig').combobox('getValue');
			if (configstr==""){
		    	$.messager.alert('错误提示','配置项不能为空!',"error");
  				return;
		    }
		}
		if (($('#MKBTEPType').combobox('getValue')=="R")||($('#MKBTEPType').combobox('getValue')=="CB")||($('#MKBTEPType').combobox('getValue')=="C")){
			var dataExtendConfig = $('#mygridExtendProConfig').datagrid('getRows');
			var configrows="";
		    var j=0;  
		    for(var i =0; i< dataExtendConfig.length;i++){  
		    	if ($.trim(dataExtendConfig[i].ConfigName)!=""){
			    	j=j+1;
			    	if (configstr==""){
						configstr=dataExtendConfig[i].ConfigName
						configrows='{"ConfigName":"'+dataExtendConfig[i].ConfigName+'"}'
					}else{
						configstr=configstr+"&%"+dataExtendConfig[i].ConfigName
						configrows=configrows+',{"ConfigName":"'+dataExtendConfig[i].ConfigName+'"}'
					}
		    	}
		    }
		    var configJson='{"total":'+j+',"rows":['+configrows+']}'  
		    if (configstr==""){
		    	$.messager.alert('错误提示','配置项不能为空!',"error");
  				return;
		    }
		}
		$('#mygridExtendPro').datagrid('updateRow',{
			index: $('#mygridExtendPro').datagrid('getRowIndex',record),
			row: {
				 MKBTEPName : extendproname ,
			     MKBTEPType : $('#MKBTEPType').combobox('getValue'),
			     MKBTEPConfig: configstr,
			     flag:record.flag,
			     configJson:configJson
			}
		});
		changeUpDownStatusEP();
		RefreshExtendPro();
		if (record.flag=="main"){ //扩展属性列表中的主列名称不允许删除
			//$('#btnDelExtendPro'+extendproname).addClass("disabled");
			$('#btnDelExtendPro'+extendproname).css("display","none");
		}
	}
	
	//术语扩展属性保存
	/*SaveExtendPro=function(){
		if(indexExtendProConfig!==""){
           $("#mygridExtendProConfig").datagrid('endEdit', indexExtendProConfig);
        }
        var record = $("#mygridExtendPro").datagrid("getSelected")
        if (!(record))
		{	
			extendproid=""
		}  else {
			extendproid=record.MKBTEPRowId;
		}
    	var extendproName=$.trim($("#MKBTEPName").val());
		if (extendproName=="")
		{
			$.messager.alert('错误提示','扩展属性名称不能为空!',"error");
			return;
		}
    	if (($('#MKBTEPType').combobox('getValue')=="")||($('#MKBTEPType').combobox('getValue')=="undefined"))
		{
			$.messager.alert('错误提示','类型不能为空!',"error");
			return;
		}
		 //术语扩展属性配置项赋值
		var configstr=""
		if (($('#MKBTEPType').combobox('getValue')=="S")||($('#MKBTEPType').combobox('getValue')=="SD")){
			configstr=$('#ExtendProConfig').combobox('getValue');
		}
		if (($('#MKBTEPType').combobox('getValue')=="R")||($('#MKBTEPType').combobox('getValue')=="CB")||($('#MKBTEPType').combobox('getValue')=="C")){
			var dataExtendConfig = $('#mygridExtendProConfig').datagrid('getRows');  
		    for(var i =0; i< dataExtendConfig.length;i++){  
		    	if (configstr==""){
					configstr=dataExtendConfig[i].ConfigName
				}else{
					configstr=configstr+"&%"+dataExtendConfig[i].ConfigName
				}
		    }  
		    if (configstr==""){
		    	$.messager.alert('错误提示','配置项不能为空!',"error");
  				return;
		    }
		}
		var parref=propertyresid;
		if(parref==""){
			parref=propertyid
		}
		
		$('#form-save-ExtendPro').form('submit', { 
			url: EXTENDPRO_SAVE_ACTION_URL, 
			onSubmit: function(param){
				param.MKBTEPParRef = parref;
				param.MKBTEPRowId = extendproid;
				param.MKBTEPConfig = configstr;
			},
			success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
						$.messager.show({ 
						  title: '提示消息', 
						  msg: '提交成功', 
						  showType: 'show', 
						  timeout: 1000, 
						  style: { 
							right: '', 
							bottom: ''
						  } 
						}); 
						$('#mygridExtendPro').datagrid('load',  { 
							ClassName:"web.DHCBL.MKB.MKBTermExtendPro",         ///调用Query时
							QueryName:"GetList",
							'parref':parref
						});
						$('#mygridExtendPro').datagrid('unselectAll');  // 清空列表选中数据
				  } 
				  else { 
						var errorMsg ="提交失败！"
						if (data.errorinfo) {
							errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
						}
						$.messager.alert('操作提示',errorMsg,"error");
				}

			} 
		});
	 	RemoveExtendConfigTool();
	 	$('#form-save-ExtendPro').form("clear");
		$("#MKBTEPType").combobox('setValue','TX');
        
	}
	*/
	
	//术语扩展属性删除
	DelExtendPro=function(MKBTEPRowId,id){
		if ((MKBTEPRowId=="")||(MKBTEPRowId==undefined)||(MKBTEPRowId=="undefined")){ //前台删除
			$('#mygridExtendPro').datagrid('deleteRow',id);
			window.setTimeout(function(){
				var index=$('#mygridExtendPro').datagrid('getRowIndex',$('#mygridExtendPro').datagrid('getSelected'));
				$('#mygridExtendPro').datagrid('deleteRow',index);
				changeUpDownStatusEP();
			},50)
		}else{
			var parref=$("#mygridProperty").datagrid("getSelected").MKBTPRowId
			$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
				if (r){	
					$.ajax({
						url:EXTENDPRO_DELETE_ACTION_URL,  
						data:{
							"id":MKBTEPRowId      ///rowid
						},  
						type:"POST",   
						success: function(data){
								  var data=eval('('+data+')'); 
								  if (data.success == 'true') {
								  		$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
										/*$.messager.show({ 
										  title: '提示消息', 
										  msg: '删除成功', 
										  showType: 'show', 
										  timeout: 1000, 
										  style: { 
											right: '', 
											bottom: ''
										  } 
										});*/ 
										$('#mygridExtendPro').datagrid('load',  { 
												ClassName:"web.DHCBL.MKB.MKBTermExtendPro",         ///调用Query时
												QueryName:"GetList",
												'parref':parref
											});
										changeUpDownStatusEP();
										$('#mygridExtendPro').datagrid('unselectAll');  // 清空列表选中数据
										RefreshExtendPro();
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
			}, this);
		}
		
	}
	//术语扩展属性保存
	SaveExtendPro=function(parref,operateType){
			var extendstr="";
			var rows = $("#mygridExtendPro").datagrid("getRows"); //获取当前页的所有行
			for(var i=0;i<rows.length;i++)
			{
				if ((rows[i].MKBTEPRowId==undefined)||(rows[i].MKBTEPRowId=="undefined")){rows[i].MKBTEPRowId=""}
				if(extendstr!="") extendstr = extendstr+"*";
				extendstr=extendstr+rows[i].MKBTEPName+"^"+rows[i].MKBTEPType+"^"+rows[i].MKBTEPConfig+"^"+rows[i].MKBTEPRowId+"^"+rows[i].flag;
			}
			if (extendstr==""){ //属性保存时没有维护或不支持扩展属性时删除扩展属性
				$.ajax({
					url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermExtendPro&pClassMethod=DeleteAll",  
					data:{
						"rowid":parref  
					},  
					type:"POST",
					success: function(data){
						  var data=eval('('+data+')'); 
						  if (data.success == 'true') {
							 		/*$.messager.show({ 
									  title: '提示消息', 
									  msg: '提交成功', 
									  showType: 'show', 
									  timeout: 1000, 
									  style: { 
										right: '', 
										bottom: ''
									  } 
									}); */
							 }
							else { 
								var errorMsg ="提交失败！"
								if (data.info) {
									errorMsg =errorMsg+ '<br/>错误信息:' + data.info
								}
								$.messager.alert('操作提示',errorMsg,"error");
							}		
					}
				});
			}else{ //属性保存同时保存扩展属性
				$.ajax({
					url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermExtendPro&pClassMethod=SaveAll",  
					data:{
						"rowid":parref,    
						"extendstr":extendstr,
						"proOperateType":operateType
					},  
					type:"POST",
					success: function(data){
						  var data=eval('('+data+')'); 
						  if (data.success == 'true') {
							 		/*$.messager.show({ 
									  title: '提示消息', 
									  msg: '提交成功', 
									  showType: 'show', 
									  timeout: 1000, 
									  style: { 
										right: '', 
										bottom: ''
									  } 
									});*/ 
							 }
							else { 
								var errorMsg ="提交失败！"
								if (data.info) {
									errorMsg =errorMsg+ '<br/>错误信息:' + data.info
								}
								$.messager.alert('操作提示',errorMsg,"error");
							}		
					}
				});
			}
			
		}	
	/******************************************术语扩展属性维护结束*******************************************************/
	/******************************************术语属性维护开始***********************************************************************************************/
	//属性内容格式下拉框
	$HUI.combobox("#MKBTPType",{
		valueField:'value',
		textField:'text',
		data:[
			{value:'TX',text:'文本'},
			{value:'TA',text:'多行文本框'},
			{value:'R',text:'单选框'},	
			{value:'CB',text:'复选框'},	
			{value:'C',text:'下拉框'},	
			{value:'L',text:'列表'},	
			{value:'T',text:'树形'},	
			{value:'F',text:'表单'},										
			{value:'S',text:'引用术语'},	
			{value:'P',text:'知识应用模板'},	
			{value:'SD',text:'知识表达式'},
			//{value:'M',text:'映射'},
			{value:'SS',text:'引用起始节点'},
			{value:'ETX',text:'文本编辑器'}
			]
	});
	/*//属性内容 标识下拉框
	$HUI.combobox("#MKBTPFlag",{
		valueField:'value',
		textField:'text',
		data:[
			{value:'S',text:'诊断展示名'},
			{value:'AL',text:'常用名/别名列表'},
			{value:'DT',text:'知识应用模板'}		  
	]
	});*/
	
	/**********************术语属性配置项开始*****************************************/

	//术语属性配置项新增
	AddPropertyConfig=function(){
		if(indexPropertyConfig!==""){
	           $('#mygridPropertyConfig').datagrid('endEdit', indexPropertyConfig);
	        }
 		$('#mygridPropertyConfig').datagrid('appendRow',{  
		     ConfigName : "" 
		}) 
		 var editIndex = $('#mygridPropertyConfig').datagrid('getRows').length - 1;
		 indexPropertyConfig=editIndex
		 $('#mygridPropertyConfig').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);	 
		var editor = $('#mygridPropertyConfig').datagrid('getEditor', { index: editIndex, field: 'ConfigName' });
		if (editor) {
		    editor.target.focus();
		} else {
		    var editors = $('#mygridPropertyConfig').datagrid('getEditors', editIndex);
		    if (editors.length) {
		    	editors[0].target.focus();
		    }
		}
	}
	//术语属性配置项删除
	DelPropertyConfig=function(){
		var record = $("#mygridPropertyConfig").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}  else {
			   $.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
				if (r){	
					var index=$('#mygridPropertyConfig').datagrid('getRowIndex',record);
			   		if ($("#myWinProperty").dialog("options").title == "修改")
				   	{
						var saveFlag =tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","DeleteConfig",propertyid,index);
						if(saveFlag=="true")
						{
							$.messager.alert('提示','删除成功!',"info");
							$('#mygridPropertyConfig').datagrid('reload');
						}
						else
						{
							$.messager.alert('错误提示',saveFlag,"error");
							/*$('#mygridPropertyConfig').datagrid('load',  { 
								ClassName:"web.DHCBL.MKB.MKBTermProperty",
								QueryName:"GetConfigList",
								'rowid': propertyid
							});*/
						}
				   	}else{
				   		$('#mygridPropertyConfig').datagrid('deleteRow',index);
				   	}
				   	$('#mygridPropertyConfig').datagrid('clearSelections'); 
			 	}
			});
        }
	}
	//清除配置项配置
	RemoveConfigTool=function(){
		if ($("#trconfig").length>0){
			$("#trconfig").remove();
		}
		if ($("#trconfiggrid").length>0){
			$("#trconfiggrid").remove();
		}
		if ($("#trdefinednode").length>0){
			$("#trdefinednode").remove();
		}
	}
	//新增配置项配置
	AppendConfigTool=function(type,propertyid,config){
		//引用术语配置项
		if (type=="S"){
			var configTool="<tr id='trconfig'><td class='tdlabel'>配置项</td><td><input id='PropertyConfig' name='PropertyConfig' type='text' class='hisui-combobox'  style='width:208px' data-options='required:true'></td></tr>"
			var targetConfig = $(configTool).appendTo("#form-save-Property table");
			$.parser.parse(targetConfig);
			$("#PropertyConfig").combobox({
				url:$URL+"?ClassName=web.DHCBL.MKB.MKBTermBase&QueryName=GetDataForCmb1&ResultSetType=array",
				valueField:'MKBTBRowId',
				textField:'MKBTBDesc',
				onSelect:function(record){
					//引用树形术语可以定义起始节点
					if ($("#trdefinednode").length>0){
						$("#trdefinednode").remove();
					}
					var type = tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetType",record.MKBTBRowId);
					if (type=="T"){
						var definednodeTool="<tr id='trdefinednode'><td class='tdlabel'>起始节点</td><td><input id='PropertyDefinedNode' name='PropertyDefinedNode' type='text' class='hisui-combotree'  style='width:208px' data-options=''></td></tr>"
						var targetDefinedNode = $(definednodeTool).appendTo("#form-save-Property table");
						$.parser.parse(targetDefinedNode);
						$HUI.combotree("#PropertyDefinedNode",{
							url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmb&base="+record.MKBTBRowId
							,onBeforeExpand:function(node){
								$(this).tree('expandFirstChildNodes',node)
					        }
						});
					}
				},
				onBeforeLoad:function(){
					//修改时加载起始节点
					var type = tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetType",config);
					if (type=="T"){
						var definednodeTool="<tr id='trdefinednode'><td class='tdlabel'>起始节点</td><td><input id='PropertyDefinedNode' name='PropertyDefinedNode' type='text' class='hisui-combotree'  style='width:208px' data-options=''></td></tr>"
						var targetDefinedNode = $(definednodeTool).appendTo("#form-save-Property table");
						$.parser.parse(targetDefinedNode);
						$HUI.combotree("#PropertyDefinedNode",{
							url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmb&base="+config
							,onBeforeExpand:function(node){
								$(this).tree('expandFirstChildNodes',node)
					        }
						});
					}
				}
			});
		}
		//知识表达式配置项
		else if((type=="SD")||(type=="SS")){
			var configTool="<tr id='trconfig'><font color=red>*</font><td class='tdlabel'>配置项</td><td><input id='PropertyConfig' name='PropertyConfig' type='text' class='hisui-combobox'  style='width:208px' data-options='required:true'></td></tr>"
			var targetConfig = $(configTool).appendTo("#form-save-Property table");
			$.parser.parse(targetConfig);
			$("#PropertyConfig").combobox({
				url:$URL+"?ClassName=web.DHCBL.MKB.MKBTermBase&QueryName=GetDataForCmb1&ResultSetType=array",
				valueField:'MKBTBRowId',
				textField:'MKBTBDesc',
				mode:'remote'
			});
		}
		//映射配置项
		else if(type=="M"){
			var configTool="<tr id='trconfig'><td class='tdlabel'><font color=red>*</font>配置项</td><td><input id='PropertyConfig' name='PropertyConfig' type='text' class='hisui-combobox'  style='width:208px' data-options='required:true'></td></tr>"
			var targetConfig = $(configTool).appendTo("#form-save-Property table");
			$.parser.parse(targetConfig);
			$("#PropertyConfig").combobox({
				url:$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetList&ResultSetType=array",
				valueField:'MKBKMBRowId',
				textField:'MKBKMBDesc',
				mode:'remote'
			});
		}
		//单选框、复选框或下拉框配置项
		else if ((type=="R")||(type=="CB")||(type=="C")){
			//var trtool="<tr><td class='tdlabel'><font color=red>*</font>格式</td><input id='MKBTPType' name='MKBTPType' type='text' class='hisui-combobox'  style='width:300px' data-options=''></td></tr>"
			var targetConfigGrid=$("<tr id='trconfiggrid'><td colspan='2'><div style='width:282px;height:233px;;padding-left:10px;'><div id='mygridPropertyConfig' data-options='fit:true'></div></div></td></tr>").appendTo("#form-save-Property table");
			$.parser.parse(targetConfigGrid);
			//术语属性可编辑配置项列表
			$("#mygridPropertyConfig").datagrid({
				url:$URL,
				queryParams:{
					ClassName:"web.DHCBL.MKB.MKBTermProperty",         ///调用Query时
					QueryName:"GetConfigList",
					'rowid': propertyid
				},
				columns: [[  
				  {field:'ConfigNum',title:'ConfigNum',width:150,sortable:true,hidden:true},
				  {field:'ConfigName',title:'配置项名称',width:150,sortable:true,editor:{type:'validatebox'}}
				  ]],  //列信息
				pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
				pageSize:20,
				pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
				singleSelect:true,
				//idField:'ConfigNum', 
				rownumbers:true,    //设置为 true，则显示带有行号的列。
				fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
				remoteSort:false,  //定义是否从服务器排序数据。true
				toolbar:[{
					iconCls:'icon-add',
					text:'新增',
					id:'add_btn_PropertyConfig',
					handler:AddPropertyConfig  
				},{
					iconCls:'icon-cancel',
					text:'删除',
					id:'del_btn_PropertyConfig',
					handler:DelPropertyConfig
				}],
				 onClickCell:function(index, field, value){
			        if(indexPropertyConfig!==""){
			           $(this).datagrid('endEdit', indexPropertyConfig);
			        }
			       
			        $(this).datagrid('beginEdit', index);
			        $(this).datagrid('selectRow', index);
			        indexPropertyConfig=index;
			       /* var ed = $(this).datagrid('getEditor', {index:index,field:field});
					$(ed.target).focus().bind('blur', function(){
						$(this).datagrid('endEdit', indexPropertyConfig);
						
					});*/
			      },
			      onAfterEdit:function(index, row, changes){
			        	if (row.ConfigName==""){
			        		$.messager.alert('错误提示','配置项名称不能为空!',"error");
			        		$('#mygridPropertyConfig').datagrid('deleteRow',index);
			        		return;
			        	}else{
			        		var record = $("#mygridPropertyConfig").datagrid("getSelected"); 
				        	var existFlag="";
				        	var dataConfig = $('#mygridPropertyConfig').datagrid('getRows');   
						    for(var i =0; i< dataConfig.length;i++){  
						    	if ((row.ConfigName==dataConfig[i].ConfigName)&(record!=dataConfig[i])){
							    	existFlag="Y" ;		    		
							    }	
						    }  
						    if (existFlag=="Y")
							 {
							 	$.messager.alert('错误提示','该配置项已存在!',"error");
							 	$('#mygridPropertyConfig').datagrid('deleteRow',index);
								return;
							 }
			        	}
			      }
			});
		}
	}
	ableExtendPro=function(type){
		if (type==true){
			//启用扩展属性
			$('#refresh_btn_ExtendPro').linkbutton('enable');
			$('#add_btn_ExtendPro').linkbutton('enable');
			$('#update_btn_ExtendPro').linkbutton('enable');
			$('#MKBTEPName').attr("disabled",false); 
			$("#MKBTEPName").validatebox({required:true})
			$('#MKBTEPType').combobox('enable'); 
		}else{
			//禁用扩展属性
			$('#refresh_btn_ExtendPro').linkbutton('disable');
			$('#add_btn_ExtendPro').linkbutton('disable');
			$('#update_btn_ExtendPro').linkbutton('disable');
			$('#MKBTEPName').attr("disabled",true);  
			$("#MKBTEPName").validatebox({required:false})
			$('#MKBTEPType').combobox('disable');  
		}
	}
	/**********************术语属性配置项结束*****************************************/
	/*ableTbProperty=function(type){
		if (type==true){
			$("#TextSearchProperty").searchcombobox('enable');
			$("#btnSearchProperty").linkbutton('enable');
			$('#btnRefreshProperty').linkbutton('enable');
			$('#btnAddProperty').linkbutton('enable');
			$('#btnUpdateProperty').linkbutton('enable');
			$('#btnDelProperty').linkbutton('enable');
			$('#btnMoveProperty').menubutton('enable');
			$('#btnUpProperty').linkbutton('enable');
			$('#btnDownProperty').linkbutton('enable');
			$('#btnFirstProperty').linkbutton('enable');
		}else{
			$("#TextSearchProperty").searchcombobox('disable');
			$("#btnSearchProperty").linkbutton('disable');
			$('#btnRefreshProperty').linkbutton('disable');
			$('#btnAddProperty').linkbutton('disable');
			$('#btnUpdateProperty').linkbutton('disable');
			$('#btnDelProperty').linkbutton('disable');
			$('#btnMoveProperty').menubutton('disable');
			$('#btnUpProperty').linkbutton('disable');
			$('#btnDownProperty').linkbutton('disable');
			$('#btnFirstProperty').linkbutton('disable');
		}
	}*/
	//术语维护查询框
	$('#TextSearchProperty').searchcombobox({ 
		url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+"User.MKBTermProperty"+termdr,
		onSelect:function () 
			{	
				$(this).combobox('textbox').focus();
				SearchProperty()
		        
	        }
		});
	$('#TextSearchProperty').combobox('textbox').bind('keyup',function(e){  
		if (e.keyCode==13){ 
			SearchProperty()
		}
	}); 

	$("#btnSearchProperty").click(function (e) { 
			SearchProperty();
	})
		
	//属性清屏按钮
	$("#btnRelProperty").click(function (e) { 

			ClearProperty();
	 }) 
	//属性新增按钮
	$("#btnAddProperty").click(function (e) { 

			AddProperty();
	 })
	 //属性 修改
	$("#btnUpdateProperty").click(function (e) { 

			UpdateProperty();
	 })  
	 
	//属性 删除
	$("#btnDelProperty").click(function (e) { 

			DelProperty();
	 }) 
	 
	 //术语属性保存按钮
	/*$("#save_btn_Property").click(function (e) { 
		if ($("#myWinProperty").dialog("options").title == "新增"){
			SaveProperty("","A");
		}else{
			SaveProperty($("#mygridProperty").datagrid("getSelected").MKBTPRowId,"U");
		}
	 }) 
	  //术语属性继续新增按钮
	$("#tadd_btn_Property").click(function (e) { 
		if ($("#myWinProperty").dialog("options").title == "新增"){
			TAddProperty("");
		}else{
			TAddProperty($("#mygridProperty").datagrid("getSelected").MKBTPRowId);
		}
	 }) 
	 //术语属性关闭按钮
	 $("#close_btn_Property").click(function (e) { 
	 	$('#myWinProperty').dialog('close'); 
	 })*/
	
	 //属性复制
	 $("#CopyProperty").click(function(e){
		CopyText()
	})

	 $("#btnCopyProperty").click(function(e){
		CopyText()
	}) 								  
	
	 //属性 上移
	$("#btnUpProperty").click(function (e) { 

			OrderProperty(1);
	 }) 
	 //属性 下移
	$("#btnDownProperty").click(function (e) { 

			OrderProperty(2);
	 }) 
	 //属性 移到首行
	$("#btnFirstProperty").click(function (e) { 

			OrderProperty(3);
	 }) 
	 
	 //改变上移下移按钮状态
	changeUpDownStatus=function(rowIndex)
	{
			
			var firstrow=GetProFirstRowIndex()
			if(rowIndex==firstrow){
				$('#btnUpProperty').linkbutton('disable');
				$('#btnFirstProperty').linkbutton('disable');
			}else
			{
				$('#btnUpProperty').linkbutton('enable');
				$('#btnFirstProperty').linkbutton('enable');
			}
			var rows = $('#mygridProperty').datagrid('getRows');
			if ((rowIndex+1)==rows.length){
				$('#btnDownProperty').linkbutton('disable');
			}else
			{
				$('#btnDownProperty').linkbutton('enable');
			}
	}
	 //属性查询方法
	SearchProperty=function (){
		//var rows = $('#mygrid').datagrid('getRows');//获得所有行
        // var row = rows[0];//根据index获得其中一行。
		var desc=$("#TextSearchProperty").combobox('getText');
		$('#mygridProperty').datagrid('load',{ 
				ClassName:"web.DHCBL.MKB.MKBTermProperty",
				QueryName:"GetList",
				'termdr':termdr,
				'desc':desc
				
			})
		$('#mygridProperty').datagrid('unselectAll');
		detailId=""   //属性内容传参设置为空
	}
	//属性清屏方法
	ClearProperty=function (){
		proeditIndex = undefined;  //正在编辑的行index
		prorowsvalue=undefined;   //正在编辑的行数据

		$("#TextSearchProperty").combobox('setValue', '');
		$('#mygridProperty').datagrid('load',  { 
			ClassName:"web.DHCBL.MKB.MKBTermProperty",
			QueryName:"GetList",
			'termdr':termdr,
			'desc':""
		});
		$('#mygridProperty').datagrid('unselectAll');
		detailId=""   //属性内容传参设置为空
	}
	 //点击新增按钮
	AddProperty=function () {
		$("#myWinProperty").show();
		var myWinProperty = $HUI.dialog("#myWinProperty",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				handler:function(){
					SaveProperty("","A");
				}
			},{
				text:'继续新增',
				handler:function(){
					TAddProperty("");
				}
			},{
				text:'关闭',
				handler:function(){
					$('#myWinProperty').dialog('close'); 
				}
			}]
			/*onOpen:function(){
				document.getElementById("tadd_btn_Property").style.display = ""; //显示继续新增按钮
			}*/
		});
		
		propertyid="";
		RefreshProperty("");
	}
	
	//点击修改按钮
	UpdateProperty=function () {
		var record = $("#mygridProperty").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		$("#myWinProperty").show();
		var myWinProperty = $HUI.dialog("#myWinProperty",{
			iconCls:'icon-w-edit ',
			resizable:true,
			title:'修改',
			modal:true,
			buttons:[{
				text:'保存',
				handler:function(){
					SaveProperty($("#mygridProperty").datagrid("getSelected").MKBTPRowId,"U");
				}
			},{
				text:'关闭',
				handler:function(){
					$('#myWinProperty').dialog('close'); 
				}
			}]
			/*onOpen:function(){
				document.getElementById("tadd_btn_Property").style.display = "none"; //隐藏继续新增按钮
			}*/
		});
		propertyid=record.MKBTPRowId;
		$.cm({
			ClassName:"web.DHCBL.MKB.MKBTermProperty",
			MethodName:"OpenData",
			id: propertyid      ///rowid
		},function(jsonData){
			RefreshProperty(propertyid);
			$('#form-save-Property').form("load",jsonData);	
			AppendConfigTool(jsonData.MKBTPType,propertyid,jsonData.MKBTPConfig)
			
			var contentflag=parseInt(tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","FormValidatePro",propertyid))
			if (contentflag==1)
			{
				if(jsonData.MKBTPType=="TA")
				{
					$("#MKBTPType").combobox('enable')	
				}
				else
				{
					$("#MKBTPType").combobox('disable')
				}
				
				$('#MKBTPCodeRules').attr('disabled','disabled');
			}
			else
			{
				$("#MKBTPType").combobox('enable')
				$('#MKBTPCodeRules').removeAttr('disabled');
			}
			$("#MKBTPType").combobox('setValue',jsonData.MKBTPType)	
			
			if ((jsonData.MKBTPType=="L")||(jsonData.MKBTPType=="P")||(jsonData.MKBTPType=="T")){
				
				$HUI.combobox("#MKBTPFlag",{
					valueField:'value',
					textField:'text',
					data:[
						{value:'S',text:'诊断展示名'},
						{value:'AL',text:'常用名/别名列表'},
						{value:'DT',text:'知识应用模板'},	
						{value:'OD',text:'其他描述'}	
					],
					onSelect:function(record){
						ChangeMKBTPFlag(record)
					}
				})
				$('#MKBTPFlag').combobox('enable');
				$("#MKBTPFlag").combobox('setValue',jsonData.MKBTPFlag)	
			}
			if ((jsonData.MKBTPType=="S")||(jsonData.MKBTPType=="SD")||(jsonData.MKBTPType=="SS")){
				$("#PropertyConfig").combobox('setValue',jsonData.MKBTPConfig)
				$("#PropertyDefinedNode").combotree('setValue',jsonData.MKBTPDefinedNode)
				if(contentflag==1){
					$("#PropertyConfig").combobox('disable')
					$("#PropertyDefinedNode").combotree('disable')
				}
				else
				{
					$("#PropertyConfig").combobox('enable')
					$("#PropertyDefinedNode").combotree('enable')
				}
			}
			if (jsonData.MKBTPType=="M"){
				$("#PropertyConfig").combobox('setValue',jsonData.MKBTPConfig)
			}
			//文本，多行文本，单选，复选，下拉，引用术语，知识表达式，映射，引用起始节点,文本编辑器
			if ((jsonData.MKBTPType=="TX")||(jsonData.MKBTPType=="TA")||(jsonData.MKBTPType=="R")||(jsonData.MKBTPType=="CB")||(jsonData.MKBTPType=="C")||(jsonData.MKBTPType=="S")||(jsonData.MKBTPType=="SD")||(jsonData.MKBTPType=="M")||(jsonData.MKBTPType=="SS")||(jsonData.MKBTPType=="ETX")){
				//禁用扩展属性
				ableExtendPro(false);
			}else{
				//启用扩展属性
				ableExtendPro(true);
			}
			
		});
		
	}
	///术语属性弹窗重置表单及列表
	RefreshProperty=function(parref){
		RemoveConfigTool();
		$('#form-save-Property').form("clear");
		$('#MKBTPFlag').combobox('disable');
		$('#MKBTPCodeRules').removeAttr('disabled');
		//扩展属性重置
	 	RemoveExtendConfigTool();
	 	$('#form-save-ExtendPro').form("clear");
		$("#MKBTEPType").combobox('setValue','TX');
		ableExtendPro(false);
	   
        //术语扩展属性列
		var columnsExtendPro =[[  
			  {field:'MKBTEPRowId',title:'RowId',width:80,sortable:true,hidden:true},
			  {field:'Id',title:'Id',width:80,sortable:true,hidden:true},
			  {field:'flag',title:'标识',width:80,sortable:true,hidden:true},
			  {field:'operation',title:'操作',width:50,  
				formatter:function(value,rec,index){  
                   	//var delbtn = '<a href="#" id="btnDelExtendPro'+rec.MKBTEPRowId+'" class="delcls" onclick="DelExtendPro(\''+rec.MKBTEPRowId+'\',\''+index+'\')">删除</a>';  
					/*if ((rec.MKBTEPRowId=="")||(rec.MKBTEPRowId=="undefined")||(rec.MKBTEPRowId==undefined)){
						var btnDelExtendProId=rec.MKBTEPRowId
					}else{
						var btnDelExtendProId=rec.MKBTEPRowId.replace("||","")
					}*/
					var delbtn = '<a href="#" id="btnDelExtendPro'+rec.MKBTEPName+'" onclick="DelExtendPro(\''+rec.MKBTEPRowId+'\',\''+index+'\')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"></a>';  
                  	return delbtn;    
			  }}  ,
			  {field:'MKBTEPName',title:'扩展属性名称',width:130,sortable:true},
			  {field:'MKBTEPType',title:'类型',width:60,sortable:true, 
			  formatter:function(v,row,index){  
					if(v=='TX'){return '文本';}
					if(v=='TA'){return '多行文本框';}
					if(v=='R'){return '单选框';}
					if(v=='CB'){return '复选框';}
					if(v=='C'){return '下拉框';}
					if(v=='S'){return '引用术语';}
					if(v=='SD'){return '知识表达式';}
					if(v=='D'){return '日期';}
				}},
			  {field:'MKBTEPConfig',title:'配置项',width:100,sortable:true,
			  	formatter:function(value,rec){ 
			  		var columnConfig=rec.MKBTEPConfig
			  		if ((rec.MKBTEPType=="S")||(rec.MKBTEPType=="SD")){
			  			columnConfig=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetDesc",value)
			  		}else{
			  			if (columnConfig.indexOf("&%")>0){
				  			columnConfig=columnConfig.replace(/\&%/g,",")
				  		}
			  		}
			  		return columnConfig;
			  	}
			  },
			  {field:'sort',title:'排序',width:60,  
				formatter:function(value,rec,index){  
					var sortbtn = '<a href="#" id="btnUpExtendPro'+rec.MKBTEPName+'" onclick="OrderFunLibExtendPro(1)"><img src="../scripts/bdp/Framework/icons/mkb/shiftup.png" style="border:0px;"/></a>'
						+'<span>&nbsp;</span><a href="#" id="btnDownExtendPro'+rec.MKBTEPName+'" onclick="OrderFunLibExtendPro(2)"><img src="../scripts/bdp/Framework/icons/mkb/shiftdown.png" style="border:0px;"/></a>';  
					return sortbtn;    
			  }},
			  {field:'MKBTEPSequence',title:'顺序',width:40,sortable:true,hidden:true},
			  {field:'configJson',title:'configJson',width:80,sortable:true,hidden:true}
			  ]];
		//术语扩展属性列表
		var mygridExtendPro = $HUI.datagrid("#mygridExtendPro",{
			url:$URL,
			queryParams:{
				ClassName:"web.DHCBL.MKB.MKBTermExtendPro",         ///调用Query时
				QueryName:"GetList",
				'parref':parref
			},
			columns: columnsExtendPro,  //列信息
			pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
			pageSize:20,
			pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
			singleSelect:true,
			idField:'MKBTEPRowId', 
			rownumbers:false,    //设置为 true，则显示带有行号的列。
			fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
			remoteSort:false,  //定义是否从服务器排序数据。true
			onClickRow:function(rowIndex,rowData){
				extendproid=rowData.MKBTEPRowId;
				var MKBTPType=$("#MKBTPType").combobox('getValue')
				if ((MKBTPType=="L")||(MKBTPType=="T")||(MKBTPType=="F")||(MKBTPType=="P")||(MKBTPType=="SD")||(MKBTPType=="SS")){
					RemoveExtendConfigTool();
					AppendExtendConfigTool(rowData.MKBTEPType,rowData.MKBTEPRowId,rowData.configJson)
					$("#MKBTEPName").val(rowData.MKBTEPName)
					$("#MKBTEPType").combobox('setValue',rowData.MKBTEPType)
					if ((rowData.MKBTEPType=="S")||(rowData.MKBTEPType=="SD")){
						$("#ExtendProConfig").combobox('setValue',rowData.MKBTEPConfig)
					}
					
				}
				if ((MKBTPType=="L")||(MKBTPType=="T")){
					//扩展属性列表中的备注及检索码不允许修改、不允许删除
					if ((rowData.MKBTEPName=="备注")||(rowData.MKBTEPName=="检索码")||(rowData.MKBTEPName=="上级分类")){
						$('#update_btn_ExtendPro').linkbutton('disable');
					}else{
						$('#update_btn_ExtendPro').linkbutton('enable');
					}
				}
			},
			onLoadSuccess:function(){
				
				//设置删除按钮图标
				//$('.delcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'}); 
				if ($("#myWinProperty").dialog("options").title == "修改"){
					var record = $("#mygridProperty").datagrid("getSelected");

					if ((record.MKBTPType=="TX")||(record.MKBTPType=="TA")||(record.MKBTPType=="R")||(record.MKBTPType=="CB")||(record.MKBTPType=="C")||(record.MKBTPType=="S")||(record.MKBTPType=="SS")){
						//禁用扩展属性列删除按钮
						var rows = $("#mygridExtendPro").datagrid("getRows"); //获取当前页的所有行
						if (rows.length>0){
							for(var i=0;i<rows.length;i++)
							{
								//$('#btnDelExtendPro'+rows[i].MKBTEPRowId.replace("||","")).addClass("disabled");
								//$('#btnDelExtendPro'+rows[i].MKBTEPName).addClass("disabled");
								$('#btnDelExtendPro'+rows[i].MKBTEPName).css("display","none");
							}
						}
					}else{
						//启用扩展属性列删除按钮
						var rows = $("#mygridExtendPro").datagrid("getRows"); //获取当前页的所有行
						if (rows.length>0){
							for(var i=0;i<rows.length;i++)
							{
								//$('#btnDelExtendPro'+rows[i].MKBTEPRowId.replace("||","")).removeClass("disabled");
								//$('#btnDelExtendPro'+rows[i].MKBTEPName).removeClass("disabled");
								$('#btnDelExtendPro'+rows[i].MKBTEPName).css("display","");
								$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","");
								$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","");
								
								if ((record.MKBTPType=="L")||(record.MKBTPType=="T")){
									if ((rows[i].flag=="main")||(rows[i].MKBTEPName=="备注")||(rows[i].MKBTEPName=="检索码")||(rows[i].MKBTEPName=="上级分类")){
										//$('#btnDelExtendPro'+rows[i].MKBTEPName).addClass("disabled");
										$('#btnDelExtendPro'+rows[i].MKBTEPName).css("display","none");
										$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
										$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
									}
								   if(record.MKBTPType=="L"){
										if(i==3){ //列表型可排序的第一条扩展属性设置上移按钮不显示
											$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
											if (rows.length==4){ //可排序数据仅有一条，上移下移按钮都不显示
												$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
											}
										}
									}
									if(record.MKBTPType=="T"){
										if(i==4){ //树形可排序的第一条扩展属性设置上移按钮不显示
											$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
											if (rows.length==5){ //可排序数据仅有一条，上移下移按钮都不显示
												$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
											}
										}
									}
								}else{ //其他类型
									if(i==0){ //可排序的第一条扩展属性设置上移按钮不显示
										$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
										if (rows.length==1){ //可排序数据仅有一条，上移下移按钮都不显示
											$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
										}
									}
								}
								if (i+1==rows.length){ //最后一条扩展属性设置下移按钮不显示
									$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
								}
							}
						}
					}
				}else{
					var items = $("#mygridExtendPro").datagrid("getRows"); 
					if (items.length>0){
						 for (var i = items.length - 1; i >= 0; i--) {    
			                 var index = $('#mygridExtendPro').datagrid('getRowIndex', items[i]);    
			                 $('#mygridExtendPro').datagrid('deleteRow', index);    
			             }    
					}
				}
			}
		});
		
//改变上移下移按钮状态
changeUpDownStatusEP=function()
{
	var rows = $("#mygridExtendPro").datagrid("getRows"); //获取当前页的所有行
	if (rows.length>0){
		for(var i=0;i<rows.length;i++)
		{
			$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","");
			$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","");
			if (($("#MKBTPType").combobox("getValue")=="L")||($("#MKBTPType").combobox("getValue")=="T")){
				if ((rows[i].flag=="main")||(rows[i].MKBTEPName=="备注")||(rows[i].MKBTEPName=="检索码")||(rows[i].MKBTEPName=="上级分类")){
					$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
					$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
				}
				if($("#MKBTPType").combobox("getValue")=="L"){
					if(i==3){ //列表型可排序的第一条扩展属性设置上移按钮不显示
						$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
						if (rows.length==4){ //可排序数据仅有一条，上移下移按钮都不显示
							$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
						}
					}
				}
				if($("#MKBTPType").combobox("getValue")=="T"){
					if(i==4){ //树形可排序的第一条扩展属性设置上移按钮不显示
						$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
						if (rows.length==5){ //可排序数据仅有一条，上移下移按钮都不显示
							$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
						}
					}
				}
				
			}else{ //其他类型
				if(i==0){ //可排序的第一条扩展属性设置上移按钮不显示
					$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
					if (rows.length==1){ //可排序数据仅有一条，上移下移按钮都不显示
						$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
					}
				}
			}
			if (i+1==rows.length){ //最后一条扩展属性设置下移按钮不显示
				$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
			}
		}
	}

}
//上移 下移 移到首行
OrderFunLibExtendPro=function(type)
{
	setTimeout(function(){
		var row = $("#mygridExtendPro").datagrid("getSelected"); 
		if (!(row))
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}	   
		var index = $("#mygridExtendPro").datagrid('getRowIndex', row);	
		mysort(index, type, "mygridExtendPro")
		$('#mygridExtendPro').datagrid('unselectAll');  // 清空列表选中数据
		changeUpDownStatusEP()
		
		//遍历列表
		/*var order=""
		var rows = $('#mygridProperty').datagrid('getRows');	
		for(var i=0; i<rows.length; i++){	
			var id =rows[i].MKBTBPRowId; //频率id
			if (order!=""){
				order = order+"&%"+id
			}else{
				order = id
			}
		}*/
	},50)
}
		
		//属性名称失去焦点事件：对扩展属性列表操作
		$('#MKBTPDesc').bind('blur',function(){
				//根据属性名称自动生成编码规则
				if($("#MKBTPCodeRules").is(':disabled'))
				{
				}
				else
				{
					$("#MKBTPCodeRules").val(Pinyin.GetJPU($('#MKBTPDesc').val()))
			    }

				
				//根据属性名称更新树型、列表型属性的扩展属性
				if (($("#MKBTPType").combobox("getValue")=="L")||($("#MKBTPType").combobox("getValue")=="T"))
				{			
					if ($('#MKBTPFlag').combobox('getValue')=="AL")
					{
						$('#mygridExtendPro').datagrid('updateRow',{
								index: 0,
								row: {
									MKBTEPName: '别名'
								}
						})
					}
					else
					{
						var MKBTPDesc1=$("#MKBTPDesc").val()
						if((MKBTPDesc1=="")||(MKBTPDesc1=="展示名")||(MKBTPDesc1=="别名"))
						{
							MKBTPDesc1="中心词"
						}
						$('#mygridExtendPro').datagrid('updateRow',{
								index: 0,
								row: {
									MKBTEPName: MKBTPDesc1
								}
						})	
				}
			}
			var rows = $("#mygridExtendPro").datagrid("getRows"); 
			if (rows.length>0){
					for(var i=0;i<rows.length;i++)
					{
						//$('#btnDelExtendPro'+rows[i].MKBTEPName).removeClass("disabled");
						$('#btnDelExtendPro'+rows[i].MKBTEPName).css("display","");
						$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","");
						$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","");
						if (($("#MKBTPType").combobox("getValue")=="L")||($("#MKBTPType").combobox("getValue")=="T")){
								if ((rows[i].flag=="main")||(rows[i].MKBTEPName=="备注")||(rows[i].MKBTEPName=="检索码")||(rows[i].MKBTEPName=="上级分类")){
									//$('#btnDelExtendPro'+rows[i].MKBTEPName).addClass("disabled");
									$('#btnDelExtendPro'+rows[i].MKBTEPName).css("display","none");
									$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
									$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
								}
								if($("#MKBTPType").combobox("getValue")=="L"){
									if(i==3){ //列表型可排序的第一条扩展属性设置上移按钮不显示
										$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
										if (rows.length==4){ //可排序数据仅有一条，上移下移按钮都不显示
											$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
										}
									}
								}
								if($("#MKBTPType").combobox("getValue")=="T"){
									if(i==4){ //树形可排序的第一条扩展属性设置上移按钮不显示
										$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
										if (rows.length==5){ //可排序数据仅有一条，上移下移按钮都不显示
											$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
										}
									}
								}
								
							}
							else{ //其他类型
								if(i==0){ //可排序的第一条扩展属性设置上移按钮不显示
									$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
									if (rows.length==1){ //可排序数据仅有一条，上移下移按钮都不显示
										$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
									}
								}
							}
							if (i+1==rows.length){ //最后一条扩展属性设置下移按钮不显示
								$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
							}
						}
					}
		  }); 
		  //标识切换事件
		ChangeMKBTPFlag=function(record){
				if(record.value=="AL")
				{
					var mainindex=0
					var items = $("#mygridExtendPro").datagrid("getRows"); 
					if (items.length>0){
						 for (var i = items.length - 1; i >= 0; i--) { 
						 	if (((items[i].MKBTEPName=="展示名")||(items[i].MKBTEPName=="别名"))&& (items[i].flag!=="main"))
						 	{
			                 	var index = $('#mygridExtendPro').datagrid('getRowIndex', items[i]);    
			                	 $('#mygridExtendPro').datagrid('deleteRow', index); 
						 	}
						 	else if(items[i].flag=="main")
						 	{
						 		var mainindex=$('#mygridExtendPro').datagrid('getRowIndex', items[i])
						 	}
			             }    
					}
					$('#mygridExtendPro').datagrid('updateRow',{
							index: mainindex,
							row: {
								MKBTEPName: '别名'
							}
					})
				}
				else if((record.value=="S")||(record.value==""))
				{
					var MKBTPDesc1=$("#MKBTPDesc").val()
					if((MKBTPDesc1=="")||(MKBTPDesc1=="展示名")||(MKBTPDesc1=="别名"))
					{
						MKBTPDesc1="中心词"
					}
					$('#mygridExtendPro').datagrid('updateRow',{
							index: 0,
							row: {
								MKBTEPName: MKBTPDesc1
							}
					})
					var items = $("#mygridExtendPro").datagrid("getRows"); 
					var shownameflag=0,othernameflag=0
					if (items.length>0){
						 for (var i = items.length - 1; i >= 0; i--) { 
						 	if (items[i].MKBTEPName=="展示名")
						 	{
			                 	shownameflag=1 
						 	}
						 	if (items[i].MKBTEPName=="别名")
						 	{
			                 	othernameflag=1 
						 	}
			             }    
					}
					if (shownameflag!==1 )
					{
						$('#mygridExtendPro').datagrid('appendRow',{  
								     MKBTEPName : "展示名" ,
								     MKBTEPType : "TX",
								     MKBTEPConfig: "",
								     flag:'',
								     Id:'4',
								     MKBTEPSequence:''
								}) 
					}
					if (othernameflag!==1 )
					{
						$('#mygridExtendPro').datagrid('appendRow',{  
								     MKBTEPName : "别名" ,
								     MKBTEPType : "TX",
								     MKBTEPConfig: "",
								     flag:'',
								     Id:'5',
								     MKBTEPSequence:''
								}) 
					}
				}
			
			var rows = $("#mygridExtendPro").datagrid("getRows"); 
			if (rows.length>0){
					for(var i=0;i<rows.length;i++)
					{
						//$('#btnDelExtendPro'+rows[i].MKBTEPName).removeClass("disabled");
						$('#btnDelExtendPro'+rows[i].MKBTEPName).css("display","");;
						$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","");
						$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","");
						if (($("#MKBTPType").combobox("getValue")=="L")||($("#MKBTPType").combobox("getValue")=="T")){
								if ((rows[i].flag=="main")||(rows[i].MKBTEPName=="备注")||(rows[i].MKBTEPName=="检索码")||(rows[i].MKBTEPName=="上级分类")){
									//$('#btnDelExtendPro'+rows[i].MKBTEPName).addClass("disabled");
									$('#btnDelExtendPro'+rows[i].MKBTEPName).css("display","none");
									$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
									$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
								}
								if($("#MKBTPType").combobox("getValue")=="L"){
									if(i==3){ //列表型可排序的第一条扩展属性设置上移按钮不显示
										$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
										if (rows.length==4){ //可排序数据仅有一条，上移下移按钮都不显示
											$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
										}
									}
								}
								if($("#MKBTPType").combobox("getValue")=="T"){
									if(i==4){ //树形可排序的第一条扩展属性设置上移按钮不显示
										$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
										if (rows.length==5){ //可排序数据仅有一条，上移下移按钮都不显示
											$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
										}
									}
								}
								
							}
							else{ //其他类型
								if(i==0){ //可排序的第一条扩展属性设置上移按钮不显示
									$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
									if (rows.length==1){ //可排序数据仅有一条，上移下移按钮都不显示
										$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
									}
								}
							}
							if (i+1==rows.length){ //最后一条扩展属性设置下移按钮不显示
								$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
							}
						}
					}
			}
		
		//格式切换事件：对扩展属性列表操作
		$("#MKBTPType").combobox({  
			onSelect:function(record){
				RemoveConfigTool();
				//格式为列表型、知识应用模板时标识可用
				if ((record.value=="L")||(record.value=="P")||(record.value=="T"))
				{
					if (record.value=="L")
					{
						$HUI.combobox("#MKBTPFlag",{
							valueField:'value',
							textField:'text',
							data:[
								{value:'S',text:'诊断展示名'},
								{value:'AL',text:'常用名/别名列表'}	  
							],
							onSelect:function(record){
								ChangeMKBTPFlag(record)
							}
						});
					}
					else if(record.value=="T"){
						$HUI.combobox("#MKBTPFlag",{
							valueField:'value',
							textField:'text',
							data:[
								{value:'OD',text:'其他描述'}		  
							]
						});
					}
					else
					{
						$HUI.combobox("#MKBTPFlag",{
							valueField:'value',
							textField:'text',
							data:[
								{value:'DT',text:'知识应用模板'}		  
							]
						});
					}
					$('#MKBTPFlag').combobox('enable');
				}
				else
				{
					$('#MKBTPFlag').combobox('setValue','');
					$('#MKBTPFlag').combobox('disable');
				}
				
				
				RemoveExtendConfigTool();
				$('#form-save-ExtendPro').form("clear");
				$("#MKBTEPType").combobox('setValue','TX');
				AppendConfigTool(record.value,"");
				$("#mygridPropertyConfig").datagrid('reload')
				
				
				var items = $("#mygridExtendPro").datagrid("getRows"); 
				if (items.length>0){
					 for (var i = items.length - 1; i >= 0; i--) {    
		                 var index = $('#mygridExtendPro').datagrid('getRowIndex', items[i]);    
		                 $('#mygridExtendPro').datagrid('deleteRow', index);    
		             }    
				}
				if ($("#myWinProperty").dialog("options").title == "修改"){
					var recordSelect = $("#mygridProperty").datagrid("getSelected");
					if (recordSelect.MKBTPType==record.value){
						$('#mygridExtendPro').datagrid('load',  { 
								ClassName:"web.DHCBL.MKB.MKBTermExtendPro",       
								QueryName:"GetList",
								'parref':recordSelect.MKBTBPRowId
							});
						
					}
				}
				
				//文本，多行文本，单选，复选，下拉，引用术语，知识表达式，映射，引用起始节点,文本编辑器
				if ((record.value=="TX")||(record.value=="TA")||(record.value=="R")||(record.value=="CB")||(record.value=="C")||(record.value=="S")||(record.value=="SD")||(record.value=="M")||(record.value=="SS")||(record.value=="ETX")){
					ableExtendPro(false)
					//禁用扩展属性列删除按钮
					var rows = $("#mygridExtendPro").datagrid("getRows"); //获取当前页的所有行
					if (rows.length>0){
						for(var i=0;i<rows.length;i++)
						{
							//$('#btnDelExtendPro'+rows[i].MKBTEPName).addClass("disabled");
							$('#btnDelExtendPro'+rows[i].MKBTEPName).css("display","none");
						}
					}
				}else{
					ableExtendPro(true) 
					//启用扩展属性列删除按钮
					var rows = $("#mygridExtendPro").datagrid("getRows"); //获取当前页的所有行
					if (rows.length>0){
						for(var i=0;i<rows.length;i++)
						{
							//$('#btnDelExtendPro'+rows[i].MKBTEPName).removeClass("disabled");
							$('#btnDelExtendPro'+rows[i].MKBTEPName).css("display","");
						}
					}
					
					if ((record.value=="L")||(record.value=="T")){
						if ($('#MKBTPFlag').combobox('getValue')=="AL")
							{
								//主列名称，初始内容为中心词,允许修改不允许删除,保存到属性表的主列名称字段
								$('#mygridExtendPro').datagrid('appendRow',{  
								     MKBTEPName : "别名" ,//"中心词", 
								     MKBTEPType : "TX",
								     MKBTEPConfig: "",
								     flag:"main",
								     Id:'1',
								     MKBTBEPSequence:''
								}) 
								//备注， 不能修改不能删除，要显示，不保存
								$('#mygridExtendPro').datagrid('appendRow',{  
								     MKBTEPName : "备注" ,
								     MKBTEPType : "TA",
								     MKBTEPConfig: "",
								     Id:'2',
								     MKBTBEPSequence:''
								}) 
								//检索码， 不允许修改删除
								$('#mygridExtendPro').datagrid('appendRow',{  
								     MKBTEPName : "检索码" ,
								     MKBTEPType : "TX",
								     MKBTEPConfig: "",
								     Id:'3',
								     MKBTBEPSequence:''
								}) 
								//树形格式属性需生成扩展属性上级分类， 不允许修改删除，要显示，不保存
								if (record.value=="T"){
									$('#mygridExtendPro').datagrid('appendRow',{  
									     MKBTEPName : "上级分类" ,
									     MKBTEPType : "TX",
									     MKBTEPConfig: "",
									     flag:'',
									     Id:'4',
									     MKBTBEPSequence:''
									}) 
								}
								
							
							}
							else
							{
								//主列名称，初始内容为中心词,允许修改不允许删除,保存到属性表的主列名称字段
								var MKBTPDesc1=$("#MKBTPDesc").val()
								if((MKBTPDesc1=="")||(MKBTPDesc1=="展示名")||(MKBTPDesc1=="别名"))
								{
									MKBTPDesc1="中心词"
								}
								
								$('#mygridExtendPro').datagrid('appendRow',{  
								     MKBTEPName : MKBTPDesc1 , //"中心词",
								     MKBTEPType : "TX",
								     MKBTEPConfig: "",
								     flag:"main",
								     Id:'1',
								     MKBTBEPSequence:''
								}) 
								//备注， 不能修改不能删除，要显示，不保存
								$('#mygridExtendPro').datagrid('appendRow',{  
								     MKBTEPName : "备注" ,
								     MKBTEPType : "TA",
								     MKBTEPConfig: "",
								     Id:'2',
								     MKBTBEPSequence:''
								}) 
								//检索码， 不允许修改删除
								$('#mygridExtendPro').datagrid('appendRow',{  
								     MKBTEPName : "检索码" ,
								     MKBTEPType : "TX",
								     MKBTEPConfig: "",
								     Id:'3',
								     MKBTBEPSequence:''
								}) 
								k=5
								//树形格式属性需生成扩展属性上级分类， 不允许修改删除，要显示，不保存
								if (record.value=="T"){
									//上级分类， 不允许修改删除
									$('#mygridExtendPro').datagrid('appendRow',{  
									     MKBTEPName : "上级分类" ,
									     MKBTEPType : "TX",
									     MKBTEPConfig: "",
									     Id:'6',
									     MKBTBEPSequence:''
									}) 
									k=6
								}
							$('#mygridExtendPro').datagrid('appendRow',{  
							     MKBTEPName : "展示名" ,
							     MKBTEPType : "TX",
							     MKBTEPConfig: "",
							     Id:'4',
							     MKBTBEPSequence:''
							}) 
							$('#mygridExtendPro').datagrid('appendRow',{  
							     MKBTEPName : "别名" ,
							     MKBTEPType : "TX",
							     MKBTEPConfig: "",
							     Id:'5',
							     MKBTBEPSequence:''
							}) 
						}
					}
					//知识应用模板
					if (record.value=="P"){
						$('#mygridExtendPro').datagrid('appendRow',{  
							     MKBTEPName : "缺省展示效果" ,
							     MKBTEPType : "TX",
							     MKBTEPConfig: ""
							}) 
						
					}
				if (rows.length>0){
						for(var i=0;i<rows.length;i++)
						{
							//$('#btnDelExtendPro'+rows[i].MKBTEPName).removeClass("disabled");
							$('#btnDelExtendPro'+rows[i].MKBTEPName).css("display","");
							$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","");
							$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","");
							if ((record.value=="L")||(record.value=="T")){
									
									if(record.value=="L"){
										if(i==3){ //列表型可排序的第一条扩展属性设置上移按钮不显示
											$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
											if (rows.length==4){ //可排序数据仅有一条，上移下移按钮都不显示
												$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
											}
										}
									}
									if(record.value=="T"){
										if(i==4){ //树形可排序的第一条扩展属性设置上移按钮不显示
											$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
											if (rows.length==5){ //可排序数据仅有一条，上移下移按钮都不显示
												$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
											}
										}
									}
									if ((rows[i].flag=="main")||(rows[i].MKBTEPName=="备注")||(rows[i].MKBTEPName=="检索码")||(rows[i].MKBTEPName=="上级分类")){
										//$('#btnDelExtendPro'+rows[i].MKBTEPName).addClass("disabled");
										$('#btnDelExtendPro'+rows[i].MKBTEPName).css("display","none");
										$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
										$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
									}
								}
								else{ //其他类型
									if(i==0){ //可排序的第一条扩展属性设置上移按钮不显示
										$('#btnUpExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
										if (rows.length==1){ //可排序数据仅有一条，上移下移按钮都不显示
											$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
										}
									}
								}
								if (i+1==rows.length){ //最后一条扩展属性设置下移按钮不显示
									$('#btnDownExtendPro'+rows[i].MKBTEPName).css("visibility","hidden");
								}
							}
						}
						
				}
			}
		});
		  
	  
	}
	///新增、更新
	SaveProperty=function(id,operateType)
	{		
		 if(indexPropertyConfig!==""){
	           $("#mygridPropertyConfig").datagrid('endEdit', indexPropertyConfig);
	        }
		if ($.trim($("#MKBTPDesc").val())=="")
		{
			$.messager.alert('错误提示','属性名称不能为空!',"error");
			return;
		}
		if (($('#MKBTPType').combobox('getValue')=="")||($('#MKBTPType').combobox('getValue')=="undefined"))
		{
			$.messager.alert('错误提示','格式不能为空!',"error");
			return;
		}
		if ($('#MKBTPFlag').combobox('getValue')!=""){
			var flag = tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","ValidateFlag",id,$('#MKBTPFlag').combobox('getValue'),termdr);
			if (flag==1){
				$.messager.alert('错误提示','已经存在此标识的属性!',"error");
				return;
			}
		}
		if ($.trim($("#MKBTPCodeRules").val())=="")
		{
			$.messager.alert('错误提示','编码规则不能为空!',"error");
			return;
		}
		//配置项赋值
		var configstr=""
		var definednode=""
		if ($('#MKBTPType').combobox('getValue')=="S"){
			configstr=$('#PropertyConfig').combobox('getValue');
			if (configstr==""){
		    	$.messager.alert('错误提示','配置项不能为空!',"error");
  				return;
		    }
			var type = tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetType",configstr);
			if (type=="T"){
				//起始节点赋值
				if ($('#PropertyDefinedNode').combotree('getText')=='')
				{
					$('#PropertyDefinedNode').combotree('setValue','')
				}
				definednode=$('#PropertyDefinedNode').combotree('getValue');	
			}
		}
		if (($('#MKBTPType').combobox('getValue')=="SD")||($('#MKBTPType').combobox('getValue')=="M")||($('#MKBTPType').combobox('getValue')=="SS")){
			configstr=$('#PropertyConfig').combobox('getValue');
			if (configstr==""){
		    	$.messager.alert('错误提示','配置项不能为空!',"error");
  				return;
		    }
		}
		if (($('#MKBTPType').combobox('getValue')=="R")||($('#MKBTPType').combobox('getValue')=="CB")||($('#MKBTPType').combobox('getValue')=="C")){
			var dataConfig = $('#mygridPropertyConfig').datagrid('getRows');  
		    for(var i =0; i< dataConfig.length;i++){ 
		    	if ($.trim(dataConfig[i].ConfigName)!=""){
			    	if (configstr==""){
						configstr=dataConfig[i].ConfigName
					}else{
						configstr=configstr+"&%"+dataConfig[i].ConfigName
					}
		    	}
		    }  
		    if (configstr==""){
		    	$.messager.alert('错误提示','配置项不能为空!',"error");
  				return;
		    }
		}
		
		$('#form-save-Property').form('submit', { 
			url: PROPERTY_SAVE_ACTION_URL,
			onSubmit: function(param){
				param.MKBTPTermDr = termdr;
				param.MKBTPRowId = id;
				param.MKBTPConfig = configstr;
				param.MKBTPDefinedNode = definednode;
				param.MKBTPCodeRules = $("#MKBTPCodeRules").val();
			},
			success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
						propertyresid=data.id;
				  		propertyid=data.id;
				  		var MKBTBPType=$("#MKBTPType").combobox('getValue')
						SaveExtendPro(propertyresid,operateType);//保存扩展属性
						$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
							/*if (id!="")
							{
								$('#mygridProperty').datagrid('reload');  // 重新载入当前页面数据 
							}
							else{
								
								$.cm({
									ClassName:"web.DHCBL.MKB.MKBTermProperty",         ///调用Query时
									QueryName:"GetList",
									'termdr':termdr,
									 rowid: data.id   
								},function(jsonData){
									$('#mygridProperty').datagrid('insertRow',{
									index:0,
									row:jsonData.rows[0]
									})
									if ((jsonData.rows[0].MKBTPType=="TX")||(jsonData.rows[0].MKBTPType=="TA")||(jsonData.rows[0].MKBTPType=="R")||(jsonData.rows[0].MKBTPType=="CB")||(jsonData.rows[0].MKBTPType=="C")||(jsonData.rows[0].MKBTPType=="SD"))
									{ 
										var col=$('#mytbarProperty').next().find('tr[datagrid-row-index=0]')[0];
										$(col).find('.datagrid-row-expander').removeClass('datagrid-row-expand');
									}
								})
							 	
					
							}*/
							$('#mygridProperty').datagrid('reload');
							$('#myWinProperty').dialog('close'); // close a dialog
							
					}else if(data.success == 'repeat'){
				  		propertyresid=data.id;
				  		var MKBTPType=$("#MKBTPType").combobox('getValue')
				  		SaveExtendPro(propertyresid,operateType);//保存扩展属性
				  		var errorMsg = '提交成功!';
						if (data.errorinfo) {
							errorMsg = errorMsg+ '<br/>提示信息:' + data.errorinfo
						}
						$.messager.alert('操作提示',errorMsg,"info");
						$('#myWinProperty').dialog('close'); // close a dialog
						$('#mygridProperty').datagrid('reload');  // 重新载入当前页面数据 
				  }
					
				  else { 
						var errorMsg ="提交失败！"
						if (data.errorinfo) {
							errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
						}
						$.messager.alert('操作提示',errorMsg,"error");
						/*$('#mygridPropertyConfig').datagrid('load',  { 
								ClassName:"web.DHCBL.MKB.MKBTermProperty",
								QueryName:"GetConfigList",
								'rowid': id
							});*/
		
				}
			}
		});
	}
	//术语属性继续新增
	TAddProperty=function (id,operateType)
	{	
		if(indexPropertyConfig!==""){
	           $("#mygridPropertyConfig").datagrid('endEdit', indexPropertyConfig);
	        }
		if ($.trim($("#MKBTPDesc").val())=="")
		{
			$.messager.alert('错误提示','属性名称不能为空!',"error");
			return;
		}
		if (($('#MKBTPType').combobox('getValue')=="")||($('#MKBTPType').combobox('getValue')=="undefined"))
		{
			$.messager.alert('错误提示','格式不能为空!',"error");
			return;
		}
		if ($('#MKBTPFlag').combobox('getValue')!=""){
			var flag = tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","ValidateFlag",id,$('#MKBTPFlag').combobox('getValue'),termdr);
			if (flag==1){
				$.messager.alert('错误提示','已经存在此标识的属性!',"error");
				return;
			}
		}
		if ($.trim($("#MKBTPCodeRules").val())=="")
		{
			$.messager.alert('错误提示','编码规则不能为空!',"error");
			return;
		}
		//配置项赋值
		var configstr=""
		var definednode=""
		if (($('#MKBTPType').combobox('getValue')=="S")||($('#MKBTPType').combobox('getValue')=="SD")||($('#MKBTPType').combobox('getValue')=="M")||($('#MKBTPType').combobox('getValue')=="SS")){
			configstr=$('#PropertyConfig').combobox('getValue');
			if (configstr==""){
		    	$.messager.alert('错误提示','配置项不能为空!',"error");
  				return;
		    }
			var type = tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetType",configstr);
			if (type=="T"){
				//起始节点赋值
				definednode=$('#PropertyDefinedNode').combotree('getValue');	
			}
		}
		if (($('#MKBTPType').combobox('getValue')=="R")||($('#MKBTPType').combobox('getValue')=="CB")||($('#MKBTPType').combobox('getValue')=="C")){
			var dataConfig = $('#mygridPropertyConfig').datagrid('getRows');  
		    for(var i =0; i< dataConfig.length;i++){  
		    	if (configstr==""){
					configstr=dataConfig[i].ConfigName
				}else{
					configstr=configstr+"&%"+dataConfig[i].ConfigName
				}
		    }  
		    if (configstr==""){
		    	$.messager.alert('错误提示','配置项不能为空!',"error");
  				return;
		    }
		}
    			
		$('#form-save-Property').form('submit', { 
			url: PROPERTY_SAVE_ACTION_URL, 
			onSubmit: function(param){
				param.MKBTPTermDr = termdr;
				param.MKBTPRowId = id;
				param.MKBTPConfig = configstr;
				param.MKBTPDefinedNode = definednode;
			},
			success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
				  		propertyresid=data.id;
				  		var MKBTPType=$("#MKBTPType").combobox('getValue')
				  		SaveExtendPro(propertyresid,operateType);//保存扩展属性
				  		$('#myWinProperty').dialog({title: "新增"});
				  		propertyid="";
				  		RefreshProperty("");
				  		$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
						$('#mygridProperty').datagrid('reload');  // 重新载入当前页面数据 
				  }
				  else if(data.success == 'repeat'){
				  		propertyresid=data.id;
				  		var MKBTPType=$("#MKBTPType").combobox('getValue')
				  		SaveExtendPro(propertyresid,operateType);//保存扩展属性
				  		$('#myWinProperty').dialog({title: "新增"});
				  		propertyid="";
				  		RefreshProperty("");
				  		var errorMsg = '提交成功!';
						if (data.errorinfo) {
							errorMsg = errorMsg+ '<br/>提示信息:' + data.errorinfo
						}
						$.messager.alert('操作提示',errorMsg,"info");
						$('#mygridProperty').datagrid('reload');  // 重新载入当前页面数据 
				  }
				  else { 
						var errorMsg ="提交失败！"
						if (data.errorinfo) {
							errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
						}
						$.messager.alert('操作提示',errorMsg,"error");
				}

			} 
		});
	}
	///删除
	DelProperty=function()
	{        
		var record = $("#mygridProperty").datagrid("getSelected"); 
		if (!(record))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){	
				$.ajax({
					url:PROPERTY_DELETE_ACTION_URL,  
					data:{
						"id":record.MKBTPRowId      ///rowid
					},  
					type:"POST",   
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
							  		$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
									RefreshSearchData("User.MKBTermProperty"+termdr,record.MKBTPRowId,"D","")
									$('#mygridProperty').datagrid('reload');  // 重新载入当前页面数据  
									$('#mygridProperty').datagrid('unselectAll');  // 清空列表选中数据
									proeditIndex = undefined;
									prorowsvalue=undefined;
							  } 
							  else { 
							  	var errorMsg =""
								if (data.info) {																
									if (data.info.indexOf("引用")!=-1)
									{
										errorMsg =data.info+ '<br/><font style="color:red;">确定要删除该数据及所有引用数据吗？</font>'
										$.messager.confirm('提示', errorMsg, function(r){
											if (r){
												DelReferDataProperty(record.MKBTPRowId)
											}
										});
									}
									else
									{
										var errorMsg ="删除失败！"
										if (data.info) {
											errorMsg =errorMsg+ '<br/>错误信息:' + data.info
										}
										$.messager.alert('操作提示',errorMsg,"error");
									}
								}
					
							}			
					}  
				})
			}
		});
	}
	//删除引用数据
	DelReferDataProperty=function(referID)
	{        
		if (referID=="")
		{
			return
		}

		var data=tkMakeServerCall('web.DHCBL.MKB.MKBTermProperty','DeleteDataAndRefer',referID);
		  var data=eval('('+data+')'); 
		  if (data.success == 'true') {
		  	    $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
				$('#mygridProperty').datagrid('reload');  // 重新载入当前页面数据  
				$('#mygridProperty').datagrid('unselectAll');  // 清空列表选中数据
		  } 
		  else { 
				var errorMsg ="删除失败！"
				if (data.info) {
					errorMsg =errorMsg+ '<br/>错误信息:' + data.info
				}
				$.messager.alert('操作提示',errorMsg,"error");
	
	
		}					

	}
	//获取属性第一行所在的行号
	GetProFirstRowIndex=function() { 
		var Profirstrow=0
		var options = $("#mygridProperty" ).datagrid("getPager").data("pagination").options;
		var currentpage = options.pageNumber;
		 if ((basetype=="T")&&(currentpage==1))
		 {
			 Profirstrow=4
		 }
		 if ((basetype=="L")&&(currentpage==1))
		 {
			 Profirstrow=3
		 }
		 return Profirstrow
		
	}
	
	///属性上移、下移、移动到首行
	OrderProperty=function (type){  
		//更新
		var row = $("#mygridProperty").datagrid("getSelected"); 
		if (!(row))
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}	   
		var index = $("#mygridProperty").datagrid('getRowIndex', row);	
		Propertysort(index, type, "mygridProperty")
		
		//改变上移、下移按钮的状态
		var nowrow = $('#mygridProperty').datagrid('getSelected');  
		var rowIndex=$('#mygridProperty').datagrid('getRowIndex',nowrow); 
		changeUpDownStatus(rowIndex)
		//遍历列表
		var order=""
		var rows = $('#mygridProperty').datagrid('getRows');
		var firstrow=GetProFirstRowIndex()
		var Sequence=parseInt(rows[firstrow].MKBTPSequence)
		for(var i=firstrow; i<rows.length; i++){	
			var id =rows[i].MKBTPRowId; //频率id
			var  seq=rows[i].MKBTPSequence; //顺序
			if (parseInt(seq)<Sequence)
			{
			 	Sequence=parseInt(seq)
			}
			if (order!=""){
				order = order+"^"+id
			}else{
				order = id
			}	
		}
		//获取级别默认值
		$.m({
			ClassName:"web.DHCBL.MKB.MKBTermProperty",
			MethodName:"SaveDragOrder",
			order:order,
			seq:Sequence
			},function(txtData){
			//alert(order+txtData)
			});
	}
	Propertysort=function (index, type, gridname) {
		var firstrow=GetProFirstRowIndex()
		if (1 == type) {
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
		else if (2 == type) {
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
		else { //移动到首行
			if (index != firstrow) {
				var toup = $('#' + gridname).datagrid('getData').rows[index];
				$('#' + gridname).datagrid('insertRow',{
					index:firstrow, // index start with 0
					row: toup
				});
				$('#' + gridname).datagrid('deleteRow', index+1);
				$('#' + gridname).datagrid('selectRow', firstrow);
			}	
		}
	}
	/** 复制选中属性到本术语 */
	CopyBaseProToSelf = function() {
			var record = $("#mygridProperty").datagrid("getSelected"); 
			if (!(record)) {
				$.messager.alert('提示','请选择复制的属性!',"warning");
				return;
			} else {
					propertyid = record.MKBTPRowId;
					var prodesc = record.MKBTPDesc;
					$("#myWinCopySelf").show(); 
					var myWinCopySelf = $HUI.dialog("#myWinCopySelf",{
						iconCls:'icon-w-paper',
						resizable:true,
						title:'复制到本术语',
						modal:true,
						//height:$(window).height()-70,
						buttonAlign : 'center',
						buttons:[{
							text:'复制格式',
							//iconCls:'icon-save',
							id:'save_btn_CopySelfForm',
							handler:function(){
								if ($.trim($("#CopyMKBTPDesc").val())=="")
								{
									$.messager.alert('错误提示','属性名称不能为空!',"error");
									return;
								}
								$('#form-save-CopySelf').form('submit', { 
										url: COPY_SELF_URL, 
										onSubmit: function(param){
											param.copypro = propertyid,
											param.copyall = ""
										},
										success: function (data) { 
										  var data=eval('('+data+')'); 
										  if (data.success == 'true') {
										  	$.messager.popover({msg: '复制格式成功！',type:'success',timeout: 1000});
											ClearProperty();  // 重新载入当前页面数据  
										  } 
										  else { 
											var errorMsg ="更新失败！"
											if (data.errorinfo) {
												errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
											}
											 $.messager.alert('操作提示',errorMsg,"error");
								
										}

									} 
	  							}); 
								myWinCopySelf.close();
							}
						},{
							text:'完全复制',
							//iconCls:'icon-save',
							handler:function(){
								if ($.trim($("#CopyMKBTPDesc").val())=="")
								{
									$.messager.alert('错误提示','属性名称不能为空!',"error");
									return;
								}
								$('#form-save-CopySelf').form('submit', { 
										url: COPY_SELF_URL, 
										onSubmit: function(param){
											param.copypro = propertyid,
											param.copyall = "1"
										},
										success: function (data) { 
										  var data=eval('('+data+')'); 
										  if (data.success == 'true') {
										  	$.messager.popover({msg: '完全复制成功！',type:'success',timeout: 1000}); 
											ClearProperty();  // 重新载入当前页面数据  
										  } 
										  else { 
											var errorMsg ="更新失败！"
											if (data.errorinfo) {
												errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
											}
											 $.messager.alert('操作提示',errorMsg,"error");
								
										}

									} 
	  							}); 
								myWinCopySelf.close();
							}
						}]
					});	
					$('#form-save-CopySelf').form("clear");
			}
	}
	
	/** 复制选中属性到其他术语 */
	CopyBaseProToOther = function(){
		var record = $("#mygridProperty").datagrid("getSelected"); 
			if (!(record)) {
				$.messager.alert('提示','请选择复制的属性!',"warning");
				return;
			} else {
					propertyid = record.MKBTPRowId;
					var prodesc = record.MKBTPDesc;
					$("#myWinCopyToOther").show();
					var title="复制" + termdesc + " (" + prodesc + ") 到其他术语"
					//$("#myWinCopyToOther").setTitle(title)
					var myWinCopyToOther = $HUI.dialog("#myWinCopyToOther",{
						iconCls:'icon-w-paper',
						resizable:true,
						title:title,
						modal:true,
						showType:'fade',
						buttonAlign : 'center',
						buttons:[{
							text:'复制格式',
							//iconCls:'icon-save',
							id:'save_btn_CopyToOtherForm',
							handler:function(){
								saveCopyBaseProToOtherData("")
								myWinCopyToOther.close();
							}	
						},{
							text:'完全复制',
							//iconCls:'icon-save',
							id:'save_btn_CopyToOtherAll',
							handler:function(){
								saveCopyBaseProToOtherData("1")
								myWinCopyToOther.close();
							}
						}]
					});
					/*options={};
					if(basetype=="T"){	
						options.url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmb&base="+base
					}
					else{
						options.url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetCopyTreeJson&diaId="+termdr+"&baseID="+base
					}
					$('#myChecktree').tree(options); 
					$HUI.radio("#myChecktreeFilterCK0").setValue(true)  //初始设置为全部 */
					$('#myChecktree').datagrid("clearSelections"); 
					$('#myChecktree').datagrid("clearChecked"); 
					$("#myChecktreeDesc").val("")
			}
	}
	saveCopyBaseProToOtherData = function(copyall){
		//var nodes = $('#myChecktree').tree('getChecked')
		var nodes=$('#myChecktree').datagrid('getChecked')
		var repTextStr=""	//复制失败的术语名　用＾连接
		var hasRepeat=""    //复制成功与否的标识,有重复属性
		var repeatStr=""  //术语ID^该术语重复的属性ＩＤ　用＆连接
		var hasCheck=""  //选中标识
		var result=true  //返回值							
		for(var i=0; i<nodes.length; i++){
			hasCheck=true
			//var rtn = tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","CopyToOtherTrem",nodes[i].id,propertyid,copyall);
			var rtn = tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","CopyToOtherTrem",nodes[i].MKBTRowId,propertyid,copyall);
			var rtn=eval('('+rtn+')'); 
			if (rtn.success == 'true') {
			 } 
			 else 
			 {
			  	hasRepeat=true
			  	var repeatPro=rtn.repeatPro　　//重复的属性ＩＤ
				//术语ID^该术语重复的属性ＩＤ
				/*if (repeatStr!="") repeatStr=repeatStr+"&"+nodes[i].id+"^"+repeatPro;
				else repeatStr=nodes[i].id+"^"+repeatPro;*/
				if (repeatStr!="") repeatStr=repeatStr+"&"+nodes[i].MKBTRowId+"^"+repeatPro;
				else repeatStr=nodes[i].MKBTRowId+"^"+repeatPro;
				//复制失败的术语名
				/*if (repTextStr!="") repTextStr=repTextStr+"、"+nodes[i].text;
				else repTextStr=nodes[i].text;*/
				if (repTextStr!="") repTextStr=repTextStr+"、"+nodes[i].MKBTDesc;
				else repTextStr=nodes[i].MKBTDesc
			}
		}
		//alert(hasCheck+","+hasRepeat+","+repeatStr)
		//如果术语已经有该属性，则弹出窗口显示该术语属性的内容，和要复制的属性进行对比，可以选择【删除并继续复制】还是【保留并放弃复制】的操作
		var saveOneCopyBaseProToOtherData=function(nodeid,propertyid,copyall,base,repeatPro){
	        //var result=true
			var repeatProInfo = tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetRepeatProInfo",repeatPro); //该术语有重复的属性信息
			var CatInfo=repeatProInfo.split("^");
			var type=CatInfo[0];  //重复的属性格式
			var diaId=CatInfo[1];  //复制到的术语
			var diaDesc=CatInfo[2];   //复制到的术语名
	
			if (type=="L")
			{
				var link="dhc.bdp.mkb.mkbassdetaillist.csp?property="+repeatPro+"&propertyName="+propertyName; 				   
			}
			else if(type=="T")
			{
				var link="dhc.bdp.mkb.mkbassdetailtree.csp?property="+repeatPro+"&propertyName="+propertyName; 
			}
			else if(type=="F")
			{
				var link="dhc.bdp.mkb.mkbassdetailtext.csp?property="+repeatPro+"&propertyName="+propertyName;
			}
			else if(type=="P")
			{
				var link="dhc.bdp.mkb.mkbassdetailproperty.csp?property="+repeatPro+"&propertyName="+propertyName;
			}
			else if(type=="S")
			{
				var configListOrTree = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetProListOrTree",propertyid)  //引用术语是树形还是列表型
				if(configListOrTree=="T")
				{
					link="dhc.bdp.mkb.mkbassdetailtreeterm.csp?property="+repeatPro+"&propertyName="+propertyName;
				}
				else
				{
					link="dhc.bdp.mkb.mkbassdetaillistterm.csp?property="+repeatPro+"&propertyName="+propertyName;
				}
					
				//var link="dhc.bdp.mkb.mkbassdetailterm.csp?property="+repeatPro+"&propertyName="+propertyName;
				
			}
			else
			{
				var link="dhc.bdp.mkb.mkbassdetailothers.csp?property="+repeatPro+"&propertyName="+propertyName;
			}
            if ('undefined'!==typeof websys_getMWToken){
                link += "&MWToken="+websys_getMWToken()
            }
			$("#myWinCopyToOtherRepeat").show();
			var myWinCopyToOtherRepeat = $HUI.dialog("#myWinCopyToOtherRepeat",{
				iconCls:'icon-w-paper',
				resizable:true,
				title:diaDesc,
				modal:true,
				content:'<iframe id="timelineCopyToOtherRepeat"  frameborder="0" src="'+link+'" width="99%" height="98%"  scrolling="no"></iframe>',
				buttonAlign : 'center',
				buttons:[{
					text:'更名复制',
					//iconCls:'icon-save',
					tooltip : '保留原属性并更名复制，并继续下一条选中术语的复制',
					handler:function(){								
						//保留原属性并更名复制新属性
						var saveRtn=tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","CopyToOtherTrem",nodeid,propertyid,"2");
						var saveRtn=eval('('+saveRtn+')');
						if (saveRtn.success == "false") {
							result=false,
							$.messager.popover({msg: '复制失败!',type:'alert',timeout: 1000});
							//alert("数据删除成功但复制失败!")
						}else{
							$.messager.popover({msg: '复制成功!',type:'success',timeout: 1000});
							
							//alert("数据删除并复制成功!")
						}
					myWinCopyToOtherRepeat.close();
				}
				},{
					text:'替换',
					//iconCls:'icon-save',
					tooltip : '删除该属性，重新复制，并继续下一条选中术语的复制',
					handler:function(){
						var rtn = tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","DeleteData",repeatPro);
						var rtn=eval('('+rtn+')'); 
						if (rtn.success == "true") {										
							//删除后进行复制
							var saveRtn=tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","CopyToOtherTrem",nodeid,propertyid,copyall);
							var saveRtn=eval('('+saveRtn+')');
							if (saveRtn.success == "false") {
								result=false,
								$.messager.popover({msg: '数据删除成功但复制失败!',type:'alert',timeout: 1000});
								//alert("数据删除成功但复制失败!")
							}else{
								$.messager.popover({msg: '数据删除并复制成功!',type:'success',timeout: 1000});
								
								//alert("数据删除并复制成功!")
							}
						myWinCopyToOtherRepeat.close();
					}else {
						result=false,
						$.messager.popover({msg: rtn.info+'数据删除并复制失败!',type:'error',timeout: 1000});
						
						//alert("数据删除并复制失败!")
				}
				}},{
					text:'放弃',
					//iconCls:'icon-cancel',
					tooltip : '保留该属性，并继续下一条选中术语的复制',
					handler:function(){
						myWinCopyToOtherRepeat.close();
					}
				}]
			})
			return myWinCopyToOtherRepeat	
		}
		//递归  当一个窗口关闭后，继续弹出下一个窗口
		var showPasWin=function(propertyid,copyall,base,repeatPro,i,repText){
			  if (i < repeatPro.length)
			  {
				    var repeat=repeatPro[i]
				    var nodeid=repeat.split("^")[0]
				    var recat=repeat.split("^")[1]
				    //alert(saveClass+"^"+saveMethod+"^"+nodeid+"^"+propertyid+"^"+copyall+"^"+base+"^"+recat)
				    
					var myWinCopyToOtherRepeat=saveOneCopyBaseProToOtherData(nodeid,propertyid,copyall,base,recat); //保存当前数据	
					$("#myWinCopyToOtherRepeat").dialog({onClose:function(){	
						i++					
						showPasWin(propertyid,copyall,base,repeatPro,i,repText)
			        }
			        });
			        myWinCopyToOtherRepeat.setTitle(repText); //+"("+propertyName+")"
					myWinCopyToOtherRepeat.open();	
					
					 
			  }
		}
		//如果没有重复的属性，则复制成功，如果有重复的属性，则对已有的属性一个个进行处理
		if(hasCheck){
			if(hasRepeat){
				$.messager.popover({msg: repTextStr+'中已经有该属性!下面对这些已有的属性进行处理!',type:'info',timeout: 1000});
				/*$.messager.show({ 
					  title: '提示消息', 
					  msg: repTextStr+"中已经有该属性!下面对这些已有的属性进行处理!", 
					  showType: 'show', 
					  timeout: 1000, 
					  style: { 
						right: '', 
						bottom: ''
					  } 
					});*/
				//alert(repTextStr+"中已经有该属性!下面对这些已有的属性进行处理!")
				var repeatPro = repeatStr.split("&");
				var repText = repTextStr.split("、")
				var i = 0
				showPasWin(propertyid,copyall,base,repeatPro,i,repText)
				
			}else{
				$.messager.popover({msg: '复制成功！',type:'success',timeout: 1000});
				
			}
		}else{
			$.messager.popover({msg: '没有选中术语！',type:'info',timeout: 1000});
			/*$.messager.show({ 
					  title: '提示消息', 
					  msg: "没有选中术语", 
					  showType: 'show', 
					  timeout: 1000, 
					  style: { 
						right: '', 
						bottom: ''
					  } 
					});	*/	
		}
		return result
	}
	//检索框
	$("#myDescCopyToOther").keyup(function(e){ 
		if (e.keyCode==13){ 
			var str = $("#myDescCopyToOther").val(); 
			$('#myChecktree').datagrid('options').queryParams={'desc':str}
			$('#myChecktree').datagrid('load');
			$('#myChecktree').datagrid('unselectAll');
			//findByRadioCheck("myChecktree",str,$("input[name='FilterCK']:checked").val())
		}
	})
	///全部、已选、未选
	/*$HUI.radio("#myWinCopyToOther [name='FilterCK']",{
        onChecked:function(e,value){
        	findByRadioCheck("myChecktree",$("#myDescCopyToOther").val(),$(e.target).attr("value"))
       }
    });*/
	 ///批量复制弹窗列表
	 var myChecktree = $HUI.datagrid("#myChecktree",{
			url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetMyList&base="+base+"&rowid="+TermID+"&sortway="+sortway+"&closeflag="+closeflag,
			columns: [[  
					  {field:'ck',checkbox:true }, 
					  {field:'MKBTRowId',title:'RowId',width:80,sortable:true,hidden:true},
					  {field:'MKBTDesc',title:'中心词',width:500,sortable:true}
					  ]],  //列信息
			pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
			pageSize:20,
			pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
			singleSelect:false,
			checkOnSelect:true,
			selectOnCheck:true,
			idField:'MKBTRowId',
			showHeader:false, 
			rownumbers:false,    //设置为 true，则显示带有行号的列。
			fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
			//remoteSort:false,  //定义是否从服务器排序数据。true
			scrollbarSize :0
	 })
	/*var myChecktree = $HUI.tree("#myChecktree",{
		//url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmb&base="+base,
		idField: 'id',
		lines:true,  //树节点之间显示线条
		autoSizeColumn:false,
		checkbox:true,
		cascadeCheck:false,  //是否级联检查。默认true  菜单特殊，不级联操作
		animate:false,     //是否树展开折叠的动画效果
		onCheck:function(node,checked)
		{
			//保存菜单批量激活隐藏状态，点击勾选框就触发后台保存，实时保存
			//var rs=tkMakeServerCall("web.DHCBL.BDP.BDPMenu","SaveActiveTree",node.id,checked)
		}
	});*/
	
  /* //测试批处理部位
   $("#btnTest").click(function(e){
		var termdrs="41164^41165"
		UpdateDiaTemplate(termdrs,"")
	}) */
	var ii,partdr,diaproid
	var termdrarr,batchtermid
	// 批量处理部位属性内容 
	UpdateDiaTemplate=function(termdrs,part){
		if (!termdrs){
			$.messager.alert('提示','没有包含该部位的术语条目!',"warning");
			return;
		}
		else
		{
			termdrarr=termdrs.split("^");
			ii=0
			partdr=part
			batchtermid=""
			//var index=termdrs.indexOf("^")
			batchtermid=termdrs//.substring(index+1)
			$("#myWinUpdateDiaTemplate").show();
			var myWinUpdateDiaTemplate = $HUI.dialog("#myWinUpdateDiaTemplate",{
			iconCls:'icon-w-paper',
			resizable:true,
			title:'修改',
			modal:true,
			onClose:function(){
				//document.getElementById("myiframeRelatedTerm").contentWindow.searchFunLib();
				}
			});
			Recursion()
		}
	
	}
	//批处理按钮
	$("#save_btn_BatchPart").click(function(e){	
				BatchPart()
        	})
     BatchPart=function(){
     	myiframeDiaTemplate.window.ClearEditStates()
     	var str=myiframeDiaTemplate.window.GetChoseProStr("M")
     	if(str=="")
     	{
     		$.messager.alert('错误提示','请先选择需要批处理的数据!',"error");
     		return;
     	}
     	if(batchtermid=="")
     	{
     		$.messager.alert('错误提示','没有需要处理的数据!',"error");
     		return;
     	}
     	var strarray=str.split(",");
     	var flagnode="";
		for (var i=0;i<strarray.length;i++){
			var arr=strarray[i].split("&");
			if (arr[2]=="")
			{
			 	flagnode=true
			}
		}
     	if (flagnode==true){
     		$.messager.confirm('确认','选中数据的节点没有定义节点，确定要进行批处理?',function(r){
			if(r){
				var rtn = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","MultiAddDiaTemplate",batchtermid,str);
				var rtn=eval('('+rtn+')'); 
				
				if (rtn.success == "true") {
					$.messager.show({
							title:'提示信息',
							msg:'批处理完成!',
							showType:'show',
							timeout:1000,
							style:{
							  right:'',
							  bottom:''
							}
						  })	
					myiframeDiaTemplate.window.ProSave()
				}else {
					result=false;
					var errorMsg="保存失败！";
					errorMsg=errorMsg+'</br>错误信息:'+rtn.info
					$.messager.alert('错误提示',errorMsg,'error')
				}
			}
		 });
     	}
     	else
     	{
     		$.messager.confirm('确认','您确定要批处理选中数据?',function(r){
			if(r){
				var rtn = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","MultiAddDiaTemplate",batchtermid,str);
				var rtn=eval('('+rtn+')'); 
				
				if (rtn.success == "true") {
					$.messager.show({
							title:'提示信息',
							msg:'批处理完成!',
							showType:'show',
							timeout:1000,
							style:{
							  right:'',
							  bottom:''
							}
						  })
					myiframeDiaTemplate.window.ProSave()
				}else {
					result=false;
					var errorMsg="保存失败！";
					errorMsg=errorMsg+'</br>错误信息:'+rtn.info
					$.messager.alert('错误提示',errorMsg,'error')
				}
			}
		 });
     	}
    	
    }
    //相关知识点查看
    $("#search_btn_RelatedKno").click(function(e){	
	        	RelatedKno()
	        })
	 RelatedKno=function(){
	 	/*var height=parseInt(window.screen.height)-120;
		var width=parseInt(window.screen.width)-50;
		//var menu=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetMenuId","临床实用诊断")
		var menuid=tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.mkb.mtm.Diagnosis");
		var repUrl="dhc.bdp.mkb.mkblistterm.csp?BDPMENU="+menuid+"&TermID="+termdrarr[ii]+"&ProId="; 
		window.open(repUrl,"_blank","height="+height+",width="+width+",left=20,top=20,resizable=yes,titlebar=no,toolbar=no,menubar=no,scrollbar=no,location=no,status=no",true)
	 */
	 	var menuid=tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.mkb.mtm.Diagnosis");
		var parentid="" //tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.mkb.mtm");
		var menuimg="" //tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetIconByID",menuid);
		//判断浏览器版本
		var Sys = {};
		var ua = navigator.userAgent.toLowerCase();
		var s;
		(s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] :
		(s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
		(s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
		(s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
		(s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
		//双击时跳转到对应界面
		//if(!Sys.ie){
		window.parent.closeNavTab(menuid)
			
		window.parent.showNavTab(menuid,"临床实用诊断",'dhc.bdp.ext.sys.csp?BDPMENU='+menuid+"&TermID="+termdrarr[ii]+"&ProId=",parentid,menuimg)
			
	 }       
	//下一条术语
	$("#next_btn_term").click(function(e){
			NextTerm()	
      })
     NextTerm=function()
     {
     	ii++	
		Recursion()
     }
     
	//批处理递归方法
	Recursion=function(){
		if (ii<termdrarr.length){
			diaproid=tkMakeServerCall('web.DHCBL.MKB.MKBTermProperty','GetDiaProDR',termdrarr[ii])
			var TermDesc=tkMakeServerCall('web.DHCBL.MKB.MKBTerm','GetDesc',termdrarr[ii])
			var UpdateDiatitle=TermDesc+"(知识应用模板)"
			diaurl="dhc.bdp.mkb.mkbtermprodetailproperty.csp?property="+diaproid+"&addTermId="+partdr;
            if ('undefined'!==typeof websys_getMWToken){
                diaurl += "&MWToken="+websys_getMWToken()
            }
			$('#myiframeDiaTemplate').attr("src",diaurl); 
			$('#myWinUpdateDiaTemplate').dialog('setTitle',UpdateDiatitle)
			//myWinUpdateDiaTemplate.setTitle(UpdateDiatitle);
        }
        //myWinUpdateDiaTemplate.setTitle(UpdateDiatitle); //+"("+propertyName+")"
		//myWinUpdateDiaTemplate.open();
        else{
        	$('#myWinUpdateDiaTemplate').dialog('close')
        	//document.getElementById("myiframe").contentWindow.searchFunLib();
        } 
	}
	
	
	/** 升级属性为术语方法 */
	PromotePro = function() {
			var record = $("#mygridProperty").datagrid("getSelected"); 
			if (!(record)) {
				$.messager.alert('提示','请选择升级的属性!',"warning");
				return;
			} else {
					propertyid = record.MKBTPRowId;
					$.messager.confirm("提示", "确定将所选属性升级为术语吗？", function (r) {
						if (r) {
							$.m({
								ClassName:"web.DHCBL.MKB.MKBTermProperty",
								MethodName:"PromotePro",
								pro:propertyid
								},function(data){
									 var data=eval('('+data+')'); 
									 if (data.success == 'true') {
									 	$.messager.confirm('提示', '升级成功，是否打开新的菜单？', function(r){
											if (r){
												var runMenuid = tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID", "dhc.bdp.mkb.mtm."+ data.baseCode);
												var parentid = tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID", "dhc.bdp.mkb.mtm");
												if (runMenuid != "") {
													var menuimg = tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetIconByID",runMenuid);
													// window.parent.showNavTab(runMenuid,jsonData.baseDesc,'dhc.bdp.ext.sys.csp?BDPMENU='+runMenuid,parentid,menuimg)
													// 判断浏览器版本
													var Sys = {};
													var ua = navigator.userAgent.toLowerCase();
													var s;
													(s = ua.match(/msie ([\d.]+)/))? Sys.ie = s[1]: (s = ua.match(/firefox\/([\d.]+)/))? Sys.firefox = s[1]: (s = ua.match(/chrome\/([\d.]+)/))? Sys.chrome = s[1]: (s = ua.match(/opera.([\d.]+)/))? Sys.opera = s[1]: (s = ua.match(/version\/([\d.]+).*safari/))? Sys.safari = s[1]: 0;
		
													// 双击时跳转到对应界面
													if (!Sys.ie) { // 新版
														window.parent.showNavTab(runMenuid,data.baseDesc,'dhc.bdp.ext.sys.csp?BDPMENU='+ runMenuid,parentid,menuimg)
													} else { // 老版
														parent.PopToTab(runMenuid,data.baseDesc,'dhc.bdp.ext.sys.csp?BDPMENU='+ runMenuid,menuimg);
													}
												}
											}
										});
									}
									else { 
										var errorMsg ="提交失败！"
										if (data.errorinfo) {
											errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
										}
										$.messager.alert('操作提示',errorMsg,"error");
				
									}		
								});
						} 
					});
					
			}
	}
	/** 升级属性为公有属性方法 */
	PublicPro = function() {
			var record = $("#mygridProperty").datagrid("getSelected"); 
			if (!(record)) 
			{
				$.messager.alert('提示','请选择升级的属性!',"warning");
				return;
			} 
			else 
			{
					var propertyid = record.MKBTPRowId;
					var MKBTPPublic=record.MKBTPPublic;
					if (MKBTPPublic == "Y") 
					{
						$.messager.alert('提示','已经是公有属性,不能升级!',"warning");
						return;
					}
					$.messager.confirm("提示", "确定升级所选属性为公有属性吗？", function (r) {
						if (r) {
							$.m({
								ClassName:"web.DHCBL.MKB.MKBTermProperty",
								MethodName:"PromoteProToPublic",
								pro:propertyid
								},function(data){
									 var data=eval('('+data+')'); 
								 	if (data.success == 'true') {
								 	//alert(1)
								 	$.messager.alert('提示',data.info,"info");
								 	ClearProperty()
								}
								else { 
									var errorMsg ="提交失败！"
									if (data.errorinfo) {
										errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
									}
									$.messager.alert('操作提示',errorMsg,"error");
			
								}		
							});
						} 
					});
					
			}
	}	
	
	//生成中间列表
	InitmygridProperty=function (termdr,ProId)
	{
		options={};  
		options.url = $URL;  
		options.pageNumber=1;
		options.queryParams = {
			ClassName:"web.DHCBL.MKB.MKBTermProperty",
			QueryName:"GetList",
			termdr:termdr,
			rowid:ProId
		};  
		//options.columns = columnsProperty;
		//options.sortName = "";  //定义可以排序的列。
		//options.title=protitle;
		$('#mygridProperty').datagrid(options);  
		//术语维护查询框
		$('#TextSearchProperty').searchcombobox({ 
			url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+"User.MKBTermProperty"+termdr,
			onSelect:function () 
			{	
				$(this).combobox('textbox').focus();
				SearchProperty()
		        
	        }
		});	
		$('#mygridProperty').datagrid('unselectAll');   
		//ShowUserHabit('mygrid');
	}
	
	/*//属性内容有变化是更新属性内容单元格
	UpdateMKBTPDDescCell=function(MKBTPRowId,MKBTPType){
		var indexFlag=$("#mygridProperty").datagrid('getRowIndex',MKBTPRowId);
		var DDesc=tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetALLDetail",MKBTPType,MKBTPRowId);
		$("#mygridProperty").datagrid('updateRow',{
			index: indexFlag,
			row:{
					MKBTPDDesc:DDesc
				}
		})
  	}
		*/
	
	//查看术语属性的版本
	SeeProVersion=function(){
		var record = $("#mygridProperty").treegrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var id=record.MKBTPRowId
        var url="dhc.bdp.mkb.mkbversion.csp?MKBVDataFlag="+"User.MKBTermProperty"+termdr+"&MKBVDataID="+id
        if ('undefined'!==typeof websys_getMWToken){
            url += "&MWToken="+websys_getMWToken()
        }
		$("#myWinVersion").show();  
		var myWinDataImport = $HUI.window("#myWinVersion",{
			resizable:true,
			collapsible:false,
			minimizable:false,
			title:'查看版本',
			iconCls:'icon-w-paper',
			modal:true,
			content:'<iframe id="timelineVersion1" frameborder="0" src="'+url+'" width="100%" height="99%" ></iframe>'
		});
	}
	//查看术语的日志
	SeeProChangeLog=function(){
		var record = $("#mygridProperty").treegrid("getSelected");
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var id=record.MKBTPRowId
        var url="dhc.bdp.mkb.mkbdatachangelog.csp?ClassName="+"User.MKBTermProperty"+termdr+"&ObjectReference="+id
		if ('undefined'!==typeof websys_getMWToken){
            url += "&MWToken="+websys_getMWToken()
        }
        $("#myWinChangeLog").show();  
		var myWinDataImport = $HUI.window("#myWinChangeLog",{
			resizable:true,
			collapsible:false,
			minimizable:false,
			title:'查看日志',
			iconCls:'icon-w-paper',
			modal:true,
			content:'<iframe id="timelineLog1"  style="border:1px solid #C0C0C0;border-radius:4px;"  src="'+url+'" width="99%" height="98%"  scrolling="no"></iframe>'
		});
	}
	
	
	
	var collExpanflag="colla";  //属性内容是否展开
	var ssbasetype="" //引用起始节点类型的配置项类型（树形或者列表型）

	var proeditIndex = undefined;  //正在编辑的行index
	var prorowsvalue=undefined;   //正在编辑的行数据
	
	
	var columnsProperty =[[  
				  {field:'MKBTPRowId',title:'RowId',width:80,sortable:true,hidden:true},
				  {field:'MKBTPDesc',title:'属性名称',width:100,sortable:true/*,editor:{type:'validatebox'}*/},
				  {field:'MKBTPDDesc',title:'属性内容',width:160,sortable:true,
				  		 formatter: function(value, row, index) {
								/*if(value.length>150)
								{
									var value1=value.substring(0,15)+"..."
									value1='<span id="MKBTPDDesctooltip"  class="hisui-tooltip" title="'+value+'" href="javascript:void(0)">'+value1+'</span>'
				  		 		}
				  		 		else
				  		 		{
				  		 			var value1=value
				  		 		}
								   return value1;*/
								//var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>'; 改成hisui的tootip
								value=value.replace(/(<[^>]+>)|(&nbsp;)/ig,""); 
						        var content ='<span id="MKBTPDDesctooltip"  class="hisui-tooltip" title="'+value+'" href="javascript:void(0)">'+value+'</span>'
						        return content;
						    }},
				  {field:'MKBTPFlag',title:'标识',width:80,sortable:true,
					  formatter:function(v,row,index){  
							if(v=='S'){return '诊断展示名';}
							if(v=='AL'){return '常用名/别名列表';}
							if(v=='DT'){return '知识应用模板';}
							if(v=='OD'){return '其他描述';}
						}},
				  {field:'MKBTPName',title:'主列名',width:100,sortable:true},
				  {field:'MKBTPType',title:'格式',width:80,sortable:true, 
					  formatter:function(v,row,index){  
							if(v=='TX'){return '文本';}
							if(v=='TA'){return '多行文本框';}
							if(v=='R'){return '单选框';}
							if(v=='CB'){return '复选框';}
							if(v=='C'){return '下拉框';}
							if(v=='L'){return '列表';}
							if(v=='F'){return '表单';}	   
							if(v=='T'){return '树形';}
							if(v=='S'){return '引用术语';}
							if(v=='P'){return '知识应用模板';}
							if(v=='SD'){return '知识表达式';}
							if(v=='M'){return '映射';}
							if(v=='SS'){return '引用起始节点';}
							if(v=='ETX'){return '文本编辑器';}
						}},
				  {field:'MKBTPConfig',title:'配置项',width:80,sortable:true,
					  formatter:function(value,rec){ 
					  		if(rec.MKBTPType=="M"){
				  				newvalue=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","GetDesc",value)
				  			}
				  			else if(rec.MKBTPType=="SS"){
				  				newvalue=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetDesc",value)
				  			}
				  			else if (value.indexOf("&%")>0){
					  			newvalue=value.replace(/\&%/g,",")
					  		}
					  		else
					  		{
					  			newvalue=value
					  		}
					  		return newvalue;
					  	}
				  	},
				  {field:'MKBTPDefinedNode',title:'起始节点',width:80,sortable:true},
				  {field:'MKBTPCodeRules',title:'编码规则',width:80,sortable:true,hidden:true},
				  {field:'MKBTPPublic',title:'公有/私有',width:80,sortable:true,
					  formatter:function(v,row,index){  
							if(v=='Y'){return '公有';}
							else{return '私有';}
						}},
				  {field:'MKBTPSequence',title:'顺序',width:80,sortable:true,hidden:true/*,
					  sorter:function (a,b){  
						    if(a.length > b.length) return 1;
						        else if(a.length < b.length) return -1;
						        else if(a > b) return 1;
						        else return -1;
						}*/},
				  {field:'MKBTPDDescF',title:'属性内容CODE',width:160,sortable:true,hidden:true,editor:'validatebox'},
				  {field:'MKBTPDDescCount',title:'属性内容数量',width:80,sortable:true,hidden:true}
				  ]];
	var columnsPropertyForCDSS =[[  
			{field:'MKBTPRowId',title:'RowId',width:80,sortable:true,hidden:true},
			{field:'MKBTPDesc',title:'属性名称',width:100,sortable:true/*,editor:{type:'validatebox'}*/},
			{field:'MKBTPDDesc',title:'属性内容',width:300,sortable:true,
						formatter: function(value, row, index) {
							value=value.replace(/(<[^>]+>)|(&nbsp;)/ig,""); 
							if(value.length>200)
							{
								var value1=value.substring(0,200)+"..."
								value1='<span id="MKBTPDDesctooltip"  class="hisui-tooltip" title="'+value+'" href="javascript:void(0)">'+value1+'</span>'
							}
							else
							{
								var value1=value
							}
							return value1;
							//var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>'; 改成hisui的tootip
							//var content ='<span id="MKBTPDDesctooltip"  class="hisui-tooltip" title="'+value+'" href="javascript:void(0)">'+value+'</span>'
							//return content;
						}},
			{field:'MKBTPFlag',title:'标识',width:80,sortable:true,hidden:true,
				formatter:function(v,row,index){  
						if(v=='S'){return '诊断展示名';}
						if(v=='AL'){return '常用名/别名列表';}
						if(v=='DT'){return '知识应用模板';}
						if(v=='OD'){return '其他描述';}
					}},
			{field:'MKBTPName',title:'主列名',width:100,sortable:true,hidden:true},
			{field:'MKBTPType',title:'格式',width:80,sortable:true,
				formatter:function(v,row,index){  
						if(v=='TX'){return '文本';}
						if(v=='TA'){return '多行文本框';}
						if(v=='R'){return '单选框';}
						if(v=='CB'){return '复选框';}
						if(v=='C'){return '下拉框';}
						if(v=='L'){return '列表';}
						if(v=='F'){return '表单';}	   
						if(v=='T'){return '树形';}
						if(v=='S'){return '引用术语';}
						if(v=='P'){return '知识应用模板';}
						if(v=='SD'){return '知识表达式';}
						if(v=='M'){return '映射';}
						if(v=='SS'){return '引用起始节点';}
						if(v=='ETX'){return '文本编辑器';}
					}},
			{field:'MKBTPConfig',title:'配置项',width:80,sortable:true,hidden:true,
				formatter:function(value,rec){ 
						if(rec.MKBTPType=="M"){
							newvalue=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","GetDesc",value)
						}
						else if(rec.MKBTPType=="SS"){
							newvalue=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetDesc",value)
						}
						else if (value.indexOf("&%")>0){
							newvalue=value.replace(/\&%/g,",")
						}
						else
						{
							newvalue=value
						}
						return newvalue;
					}
				},
			{field:'MKBTPDefinedNode',title:'起始节点',width:80,sortable:true,hidden:true},
			{field:'MKBTPCodeRules',title:'编码规则',width:80,sortable:true,hidden:true},
			{field:'MKBTPPublic',title:'公有/私有',width:80,sortable:true,hidden:true,
				formatter:function(v,row,index){  
						if(v=='Y'){return '公有';}
						else{return '私有';}
					}},
			{field:'MKBTPSequence',title:'顺序',width:80,sortable:true,hidden:true/*,
				sorter:function (a,b){  
						if(a.length > b.length) return 1;
							else if(a.length < b.length) return -1;
							else if(a > b) return 1;
							else return -1;
					}*/},
			{field:'MKBTPDDescF',title:'属性内容CODE',width:160,sortable:true,hidden:true,editor:'validatebox'},
			{field:'MKBTPDDescCount',title:'属性内容数量',width:80,sortable:true,hidden:true}
			]];
	if (TermID!="")
	{
		var maxheight=window.screen.height-320 //定义展开属性内容的高度
		if (maxheight<300)	
		{
			maxheight=300
		}
		var minheight=maxheight  //(window.screen.height-200)/2
	}
	else
	{
		var maxheight=parent.$("#myTabContent").height()-200 //定义展开属性内容的高度
		if (maxheight<300)	
		{
			maxheight=360
		}
		var minheight=maxheight  //(window.screen.height-200)/2
	}
	var mygridProperty = $HUI.datagrid("#mygridProperty",{
		/*url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.MKB.MKBTermProperty",
			QueryName:"GetList"
		},*/
		ClassTableName:'User.MKBTermProperty'+termdr,
		SQLTableName:'MKB_TermProperty',
		columns: CDSSFlag==true?columnsPropertyForCDSS:columnsProperty,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:30,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		idField:'MKBTPRowId', 
		rownumbers:false,    //设置为 true，则显示带有行号的列。
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		autoRowHeight:false,
		//remoteSort:true, //定义是否从服务器排序数据。true
		scrollbarSize :0,
		//sortName:'MKBTPSequence',
		//sortOrder:'asc',
		view: detailview,
		detailFormatter: function(rowIndex, rowData){
			//return  '<div id="p'+rowData.MKBTPRowId+'" class="hisui-panel"  style="height:400px;width:600px;padding:10px 30px 20px 30px"></div>'
			var type=rowData.MKBTPType;
			if((type=="L")||(type=="T")||(type=="F")||(type=="P")||(type=="S")||(type=="M")||(type=="SS")){
				if(rowData.MKBTPDDescCount>3){
					return "<div style='width:99%;height:"+maxheight+"px'><iframe id='i"+rowData.MKBTPRowId+"' class='myiframe' frameborder='0' src='' style='width:99%;height:98%'></iframe></div>";
				}
				else{
					return "<div style='width:99%;height:"+minheight+"px'><iframe id='i"+rowData.MKBTPRowId+"' class='myiframe' frameborder='0' src='' style='width:99%;height:98%'></iframe></div>";
				}
				
			}
			if(type=="ETX"){
				return "<div style='width:99%;height:450px'><iframe id='i"+rowData.MKBTPRowId+"' class='myiframe' frameborder='0' src='' style='width:99%;height:98%'></iframe></div>";
			}
		},
		onExpandRow:function(rowIndex,rowData){
				var expannummax=0,expannummin=0
				 $.each($('.datagrid-row-collapse'),function(i,r){
                       var ids= $(this).parent().parent().parent().attr('datagrid-row-index');
                       if ((ids<rowIndex)&(rowData.MKBTPDDescCount>3)){
                       		expannummax=expannummax+1
                       }
                       else if((ids<rowIndex)&(rowData.MKBTPDDescCount<=3)){
                       		expannummin=expannummin+1
                       }
                });
				var scrollheight=expannummax*maxheight+expannummin*minheight+rowIndex*35;  
				$(this).prev().find('div.datagrid-body').prop('scrollTop',scrollheight);
				

				propertyid=rowData.MKBTPRowId;
				property=propertyid;
				var type=rowData.MKBTPType;
				propertyName=rowData.MKBTPName;
				if (propertyName=="")
				{
					propertyName=rowData.MKBTPDesc;
				}
				if(type=="L")
				{
					contenturl="dhc.bdp.mkb.mkbtermprodetaillist.csp?property="+propertyid+"&detailId="+detailId;
				}
				else if(type=="T")
				{
					contenturl="dhc.bdp.mkb.mkbtermprodetailtree.csp?property="+propertyid+"&detailId="+detailId;
				}
				else if(type=="F")
				{
					contenturl="dhc.bdp.mkb.mkbtermprodetailtext.csp?property="+propertyid;
				}
				else if(type=="P")
				{
					contenturl="dhc.bdp.mkb.mkbtermprodetailproperty.csp?property="+propertyid;
				}
				else if(type=="S")
				{
					//contenturl="dhc.bdp.mkb.mkbtermprodetailterm.csp?property="+propertyid+"&propertyName="+propertyName;
					var configListOrTree = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetProListOrTree",propertyid)  //引用术语是树形还是列表型
					if(configListOrTree=="T")
					{
						contenturl="dhc.bdp.mkb.mkbtermprodetailtreeterm.csp?property="+propertyid+"&detailId="+detailId;
					}
					else
					{
						contenturl="dhc.bdp.mkb.mkbtermprodetaillistterm.csp?property="+propertyid+"&detailId="+detailId;
					}

				}
				else if(type=="M")
				{
					var strflag = tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingDetail","InputExpOrTermParam",rowData.MKBTPConfig,base)  //引用术语是树形还是列表型
					if(strflag=="E") //表达式
					{
						contenturl="dhc.bdp.mkb.mkbklmappingdetail.csp?mappingBase="+rowData.MKBTPConfig+"&termBase="+base+"&detailIdStr="+termdr;
					}
					else //中心词
					{
						contenturl="dhc.bdp.mkb.mkbklmappingdetail.csp?mappingBase="+rowData.MKBTPConfig+"&termBase="+base+"&termRowId="+termdr;
					}
				}
				else if(type=="SS")
				{
					contenturl="dhc.bdp.mkb.mkbtermprodetailsingleterm.csp?property="+propertyid+"&detailId="+detailId;
				}
				else if(type=="ETX")
				{
					contenturl="dhc.bdp.mkb.mkbtermprodetailhtml.csp?property="+propertyid;
				}
				else{
					contenturl=""
				}
                if (contenturl!="")
                {
                    if ('undefined'!==typeof websys_getMWToken){
                        contenturl += "&MWToken="+websys_getMWToken()
                    }
                }
                    
			$('#i'+propertyid).attr('src',contenturl)
			
		},
		onCollapseRow:function(rowIndex,rowData){
			//收缩时刷新内容单元格
			var DDesc=tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetALLDetail",rowData.MKBTPType,rowData.MKBTPRowId);
			$("#mygridProperty").datagrid('updateRow',{
				index: rowIndex,
				row:{
						MKBTPDDesc:DDesc
					}
			})
		},
		onClickRow:function(rowIndex,rowData){
			//改成hisui自带的tootip$('.mytooltip').tooltip('hide');
			//术语名称、备注、映射格式属性不能修改
			if ((rowData.MKBTPRowId.indexOf("MKBT")!=-1)||(rowData.MKBTPType=="M"))
			{
				$('#btnUpdateProperty').linkbutton('disable');
			}
			else
			{
				$('#btnUpdateProperty').linkbutton('enable');
			}
			//术语名称、备注不能移动位置
			if (rowData.MKBTPRowId.indexOf("MKBT")!=-1)
			{
				$('#btnMoveProperty').menubutton('disable');
												  
			}
			else
			{
				$('#btnMoveProperty').menubutton('enable');
				//改变上移、下移状态
				changeUpDownStatus(rowIndex);
			}
			//公有属性的位置移动不可用
			if (rowData.MKBTPPublic=="Y")
			{
				$('#btnMoveProperty').menubutton('disable');
			}
			else
			{
				$('#btnMoveProperty').menubutton('enable');
				//改变上移、下移状态
				changeUpDownStatus(rowIndex);
			}
			$('#knoExe').css('display','none');
			propertyid=rowData.MKBTPRowId;
			//保存历史和频次记录
			RefreshSearchData("User.MKBTermProperty"+termdr,propertyid,"A",rowData.MKBTPDesc)
			//可编辑功能 单击结束可编辑状态
		 	if(proeditIndex!==undefined){
		 		var lastindex=proeditIndex
	           $(this).datagrid('endEdit', proeditIndex);
	           proeditIndex=""
	          	$(this).datagrid('selectRow',lastindex);
	          	var record=$(this).datagrid('getSelected')
	          	if(record.MKBTPType=="SD"){
		          	var datacode=tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetALLDetail",record.MKBTPType,record.MKBTPRowId);
					var datadesc=tkMakeServerCall('web.DHCBL.MKB.MKBKnoExpression','GetDiagDesc',datacode)
					$("#mygridProperty").datagrid('updateRow',{
						index: lastindex,
						row:{
								MKBTPDDesc:datadesc,
								MKBTPDDescF:datacode
							}
					})
	          	}
	           
	        }
	        $(this).datagrid('clearSelections');
		    $(this).datagrid('selectRow', rowIndex);
		    
		},
		onDblClickRow:function(rowIndex,rowData){
			//改变上移、下移状态
			changeUpDownStatus(rowIndex);
			$('#knoExe').css('display','none');
			//$('.mytooltip').tooltip('hide');
			propertyid=rowData.MKBTPRowId;
			var type=rowData.MKBTPType;
			//可编辑功能 双击结束可编辑状态
		 	if(proeditIndex!==undefined){
		 		var lastindex=proeditIndex
	           $(this).datagrid('endEdit', proeditIndex);
	          	$(this).datagrid('selectRow',lastindex);
	          	var record=$(this).datagrid('getSelected')
	          	if(record.MKBTPType=="SD"){
		          	var datacode=tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetALLDetail",record.MKBTPType,record.MKBTPRowId);
					var datadesc=tkMakeServerCall('web.DHCBL.MKB.MKBKnoExpression','GetDiagDesc',datacode)
					$("#mygridProperty").datagrid('updateRow',{
						index: lastindex,
						row:{
								MKBTPDDesc:datadesc,
								MKBTPDDescF:datacode
							}
					})
	          	}
	        }
	        $(this).datagrid('clearSelections');
		    $(this).datagrid('selectRow', rowIndex);
		    
		    //判断列表、树形、表单、引用属性、引用术语是否展开
			if((type=="L")||(type=="T")||(type=="F")||(type=="P")||(type=="S")||(type=="M")||(type=="ETX")){
				if(collExpanflag=="colla")
				{
					$("#mygridProperty").datagrid('expandRow',rowIndex);
					collExpanflag="expan"
				}else{
					$("#mygridProperty").datagrid('collapseRow',rowIndex);
					//收缩时刷新内容单元格
					var DDesc=tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetALLDetail",type,rowData.MKBTPRowId);
					$("#mygridProperty").datagrid('updateRow',{
						index: rowIndex,
						row:{
								MKBTPDDesc:DDesc
							}
					})
					collExpanflag="colla"
				}
			}
			else if (type=="SS"){
				//引用初始节点展开
				if(collExpanflag=="colla")
				{
					$("#mygridProperty").datagrid('expandRow',rowIndex);
					collExpanflag="expan"
				}else{
					$("#mygridProperty").datagrid('collapseRow',rowIndex);
					//收缩时刷新内容单元格
					var DDesc=tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetALLDetail",type,rowData.MKBTPRowId);
					$("#mygridProperty").datagrid('updateRow',{
						index: rowIndex,
						row:{
								MKBTPDDesc:DDesc
							}
					})
					collExpanflag="colla"
				}
				//初始节点可编辑
				$('#mygridProperty').datagrid('updateRow',{
						index: rowIndex,
						row:{
							MKBTPDDesc:rowData.MKBTPDDescF,
							MKBTPDDescF:rowData.MKBTPDDesc
						}
					})
					
			  $(this).datagrid('beginEdit', rowIndex);
		        proeditIndex=rowIndex;
		        var col=$('#mylayoutproperty').children().find('tr[datagrid-row-index='+rowIndex+']')[1];
		        
		        var ed =  $('#mygridProperty').datagrid("getEditor",{index:proeditIndex,field:"MKBTPDDesc"});
				var idF =rowData.MKBTPDDesc
				if (ssbasetype=="T")
				{
					if ((idF!="")&(idF!=undefined)){
						var url="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmbDesc&base="+rowData.MKBTPConfig+"&id="+idF
						$(ed.target).combotree('reload',url);
					}
				}
				else
				{
					if ((idF!="")&(idF!=undefined)){
						var url="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetDataForCmb1&base="+rowData.MKBTPConfig+"&rowid="+idF
						$(ed.target).combobox('reload',url);
					}
				}
		         
				
			}
			else
			{  
				
				if(type=="SD")
				{
					//展开属性内容
					var datacode=tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetALLDetail",rowData.MKBTPType,rowData.MKBTPRowId);
					//var re=/(\n(?=(\n+)))+/g ;
					datacode=datacode.replace(/\r\n/g,"\\n");    
	        		datacode=datacode.replace(/\n/g,"\\n");
					datadesc=tkMakeServerCall('web.DHCBL.MKB.MKBKnoExpression','GetDiagDesc',datacode)
					//console.log(datadesc)
					//var datajson= JSON.parse( data );
					$('#mygridProperty').datagrid('updateRow',{
							index: rowIndex,
							row:{
								MKBTPDDesc:datadesc,
								MKBTPDDescF:datacode
							}
						})
				
				}
				
				/*else if(type=="SS")
				{
					$('#mygridProperty').datagrid('updateRow',{
						index: rowIndex,
						row:{
							MKBTPDDesc:rowData.MKBTPDDescF,
							MKBTPDDescF:rowData.MKBTPDDesc
						}
					})
				}
				else
				{
					
					//展开文本、多行文本框、单选框、复选框、下拉框的属性内容重载并且可编辑
					if(rowData!=undefined){
						var data=tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetALLDetail",rowData.MKBTPType,rowData.MKBTPRowId);
						data = data.replace(/<br\/>/g,"\n");
						$("#mygridProperty").datagrid('updateRow',{
							index: rowIndex,
							row:{
								MKBTPDDesc:data
							}
						})
					}
				}*/
				
				
		        $(this).datagrid('beginEdit', rowIndex);
		        proeditIndex=rowIndex;
		        var col=$('#mylayoutproperty').children().find('tr[datagrid-row-index='+rowIndex+']')[1];
		       
				if(type=="TA"){
					Creatdom(col,"MKBTPDDesc")
				}else if(type=="SD"){
					var sdbasedr=tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetSDBaseDR",rowData.MKBTPRowId);
					Creatdom2(col,"MKBTPDDesc",sdbasedr)
				}/*else if(type=="SS")
				{
					var ed =  $('#mygridProperty').datagrid("getEditor",{index:proeditIndex,field:"MKBTPDDesc"});
					var idF =rowData.MKBTPDDesc
					if (ssbasetype=="T")
					{
						if ((idF!="")&(idF!=undefined)){
							var url="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmbDesc&base="+rowData.MKBTPConfig+"&id="+idF
							$(ed.target).combotree('reload',url);
						}
					}
					else
					{
						if ((idF!="")&(idF!=undefined)){
							var url="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetDataForCmb1&base="+rowData.MKBTPConfig+"&rowid="+idF
							$(ed.target).combobox('reload',url);
						}
					}
				}*/
			}
		},
		onLoadSuccess: function(data){
			//检索框自动选中第一条，如果可以展开就展开，不能展开就选中,或者属性id不为空
			 var searchprovalue=$('#TextSearchProperty').combobox('getText')
			 if ((searchprovalue!="")||(ProId!=""))
			 {
			 	if (data.total!=0)
			 	{
				 	$('#mygridProperty').datagrid('selectRow',0);
					var rowData=$('#mygridProperty').datagrid('getSelected')
					if (rowData!=undefined)
					{
						if ((rowData.MKBTPType=="L")||(rowData.MKBTPType=="T")||(rowData.MKBTPType=="F")||(rowData.MKBTPType=="P")||(rowData.MKBTPType=="S")||(rowData.MKBTPType=="M")||(rowData.MKBTPType=="SS")||(rowData.MKBTPType=="ETX"))
						{
							$("#mygridProperty").datagrid('expandRow',0);
							collExpanflag="expan"
						}
					}
				 }
			}
			$(this).datagrid('columnMoving');
			//$('.mytooltip').tooltip();
			/*$('.mytooltip').tooltip({
				trackMouse:true,
				onShow:function(e){
					$(this).tooltip('tip').css({
						width:250 ,top:e.pageY+20,left:e.pageX-(250/2)
					});
				}

			});*/

			 if(data.rows.length == 0){
			 		/*
                       var body = $(this).data().datagrid.dc.body2;
                       body.find('table tbody').append('<tr><td width="' + body.width() + '" style="height:25px;text-align:center;color:#919EA6;">无属性</td></tr>');
                       */
                   }
			else
			{
				$.each(data.rows, function(index, rowdata){
					if ((rowdata.MKBTPType=="TX")||(rowdata.MKBTPType=="TA")||(rowdata.MKBTPType=="R")||(rowdata.MKBTPType=="CB")||(rowdata.MKBTPType=="C")||(rowdata.MKBTPType=="SD")||(rowdata.MKBTPRowId.indexOf("MKBTLastLevel")!=-1))
					{ 
						//移除前面的收缩、展开按钮
						var col=$('#mytbarProperty').next().find('tr[datagrid-row-index='+index+']')[0];
						$(col).find('.datagrid-row-expander').removeClass('datagrid-row-expand');
						
					}
				})
			}
         } ,
		onRowContextMenu: function(e, rowIndex, rowData){   
			//右键菜单
			var $clicked=$(e.target);
			copytext =$clicked.text()||$clicked.val()   //普通复制功能
			e.preventDefault();  //阻止浏览器捕获右键事件
			$("#mygridProperty").datagrid("selectRow", rowIndex); //根据索引选中该行  
			/*var mygridmm = $('<div style="width:80px;"></div>').appendTo('body');	
	        $(
	        '<div><span>复制</span><div style="width:200px;">'+
	        	'<div onclick="CopyBaseProToSelf()" iconCls="icon-arrow-left-top">复制选中属性到本术语</div>'+
				'<div onclick="CopyBaseProToOther()" iconCls="icon-arrow-top">复制选中属性到其他术语</div>'+
				'<div onclick="PromotePro()" iconCls="icon-arrow-bottom">把选中属性升级为术语</div>'+
				'<div onclick="PublicPro()" iconCls="icon-arrow-right-top">把选中属性升级为公有属性</div>'+
				'</div>' +'</div>'+
			'<div onclick="Extend()" iconCls="icon-copy-prn" data-options="">扩展</div>'+			
			'<div onclick="UpdateProperty()" iconCls="icon-write-order" data-options="">修改</div>'+
			'<div onclick="DelProperty()" iconCls="icon-cancel" data-options="">删除</div>'+
			'<div><span>位置移动</span><div style="width:80px;">'+
				'<div onclick="OrderProperty(1)" iconCls="icon-arrow-top">上移</div>'+
				'<div onclick="OrderProperty(2)" iconCls="icon-arrow-bottom">下移</div>'+
				'<div onclick="OrderProperty(3)" iconCls="icon-arrow-right-top">移动到首行</div>'+
				'</div>' +'</div>'
			).appendTo(mygridmm)
			mygridmm.menu()
			mygridmm.menu('show',{ 
				left:e.pageX,  
				top:e.pageY
			});*/
			if (rowData.MKBTPRowId.indexOf("MKBT")!=-1)
			{
				
			}
			else
			{
				var type=rowData.MKBTPType
				//列表和树形的才能升级为术语
				if (((type=="L")||(type=="T"))&(type!=="M"))
				{
					$('#proptoterm').css({ "cursor": "pointer", "opacity": "1" });
					$('#proptoterm').off('click.bdpcustom').on('click.bdpcustom',function(){PromotePro()})
					//$('#proptoterm').attr('onclick', '').unbind('click').click( function () {PromotePro()  })
					
				}
				else
				{
					$('#proptoterm').css({ "cursor": "default", "opacity": "0.4" });
					$('#proptoterm').off('click.bdpcustom').on('click.bdpcustom',function(){})
					//$('#proptoterm').attr('onclick', '').unbind('click').click( function () {  })
				}
				//映射类型不能复制和升级
				if (type=="M")
				{
					
					$('#proptoother').css({ "cursor": "default", "opacity": "0.4" });
					//$('#proptoother').attr('onclick', '').unbind('click').click( function () {  })
					$('#proptoother').off('click.bdpcustom').on('click.bdpcustom',function(){})
					
					$('#proptocommon').css({ "cursor": "default", "opacity": "0.4" });
					//$('#proptocommon').attr('onclick', '').unbind('click').click( function () {  })
					$('#proptocommon').off('click.bdpcustom').on('click.bdpcustom',function(){})
				}
				else
				{	
					$('#proptoother').css({ "cursor": "pointer", "opacity": "1" });
					//$('#proptoother').attr('onclick', '').unbind('click').click( function () { CopyBaseProToOther() })
					$('#proptoother').off('click.bdpcustom').on('click.bdpcustom',function(){CopyBaseProToOther()})
					
					$('#proptocommon').css({ "cursor": "pointer", "opacity": "1" });
					//$('#proptocommon').attr('onclick', '').unbind('click').click( function () { PublicPro()})
					$('#proptocommon').off('click.bdpcustom').on('click.bdpcustom',function(){PublicPro()})
					
				}
				
				var flag=rowData.MKBTPFlag
				//诊断展示名是唯一的
				//if ((flag=="S")||(type=="T"))
				//标识是唯一的 映射类型不能复制和升级
				if ((flag!=="")||(type=="M"))
				{
					$('#prop').css({ "cursor": "default", "opacity": "0.4"});
					$('#prop').off('click.bdpcustom').on('click.bdpcustom',function(){})
					//$('#prop').attr('onclick', '').unbind('click').click( function () {  })
				}else
				{
					$('#prop').css({ "cursor": "pointer", "opacity": "1" });
					$('#prop').off('click.bdpcustom').on('click.bdpcustom',function(){CopyBaseProToSelf()})
					//$('#prop').attr('onclick', '').unbind('click').click( function () {CopyBaseProToSelf()  })
				}
				var firstrow=GetProFirstRowIndex()
				//公有属性的位置移动不可用
				if (rowData.MKBTPPublic=="Y")
				{
					$('#positiondiv').attr("disabled", "disabled").css({ "cursor": "default", "opacity": "0.4" });
					$('#Propertyshiftup').attr("disabled", "disabled").css({ "cursor": "default", "opacity": "0.4" });
					$('#Propertyshiftfirst').attr("disabled", "disabled").css({ "cursor": "default", "opacity": "0.4" });		   
					$('#Propertyshiftdown').attr("disabled", "disabled").css({ "cursor": "default", "opacity": "0.4" });
				}
				else
				{
					//位置移动
					if(rowIndex==firstrow){
						$('#Propertyshiftup').attr("disabled", "disabled").css({ "cursor": "default", "opacity": "0.4" });
						$('#Propertyshiftfirst').attr("disabled", "disabled").css({ "cursor": "default", "opacity": "0.4" });
					}else
					{
						$('#Propertyshiftup').removeAttr('disabled').css({ "cursor": "pointer", "opacity": "1" });
						$('#Propertyshiftfirst').removeAttr('disabled').css({ "cursor": "pointer", "opacity": "1" });
					}
					var rows = $('#mygridProperty').datagrid('getRows');
					if ((rowIndex+1)==rows.length){
						$('#Propertyshiftdown').attr("disabled", "disabled").css({ "cursor": "default", "opacity": "0.4" });
					}else
					{
						$('#Propertyshiftdown').removeAttr('disabled').css({ "cursor": "pointer", "opacity": "1" });
					}
				}
				$('#myMenuProperty').menu('show', {    
					  left:e.pageX,  
					  top:e.pageY
				})
			}
		},
		onClickCell:function(index, field, value) {
			if(value=='TX'){copytext='文本';}
			else if(value=='TA'){copytext= '多行文本框';}
			else if(value=='R'){copytext= '单选框';}
			else if(value=='CB'){copytext= '复选框';}
			else if(value=='C'){copytext= '下拉框';}
			else if(value=='L'){copytext= '列表';}
			else if(value=='F'){copytext= '表单';}	   
			else if(value=='T'){copytext= '树形';}
			else if((value=='S')&(field=='MKBTPType')){copytext= '引用术语';}
			else if(value=='P'){copytext= '知识应用模板';}
			else if(value=='SD'){copytext= '知识表达式';}
			else if(value=='Y'){copytext= '公有';}
			else if(value=='N'){copytext= '私有';}
			else if(value=='AL'){copytext= '常用名/别名列表';}
			else if((value=='S')&(field=='MKBTPFlag')){copytext= '诊断展示名';}
			else if(value=='M'){copytext= '映射';}
			else if(value=='SS'){copytext= '引用起始节点';}
			else if(value=='ETX'){copytext= '文本编辑器';}
			else if(value=='DT'){copytext= '知识应用模板';}
			else if(value=='OD'){copytext= '其他描述';}
			else 
			{
				copytext = value  //普通复制功能
			}
		} ,  
		onAfterEdit:function(index, row, changes) {
			PropertyAfterEdit(index, row)
		},
		onBeforeEdit:function(rowIndex,row){
			$('#mygridProperty').datagrid('removeEditor', 'MKBTPDDesc');
            $('#mygridProperty').datagrid('selectRow', rowIndex);
            
 	    	// var row = $('#mygridProperty').datagrid('getSelected');
		     //根据类型加载不同格式属性内容
		      if((row.MKBTPType == 'TX')||(row.MKBTPType == 'SD')){
		         $("#mygridProperty").datagrid('addEditor', {
		              field : 'MKBTPDDesc',
		              editor : {
		                  type : 'validatebox'
		             }
		         });
		     }else if(row.MKBTPType == 'TA'){
		         $("#mygridProperty").datagrid('addEditor', {
		             field : 'MKBTPDDesc',
		             editor : {
		                 type : 'textarea'
		             }
		         });  
		     }else if(row.MKBTPType == 'R'){
		         $("#mygridProperty").datagrid('addEditor', {
		             field : 'MKBTPDDesc',
		             editor:{
			             type:'comboboxradio',
						 options:{
							valueField:'ConfigNum',
							textField:'ConfigName',
							//panelHeight: 'auto',
							url:$URL+"?ClassName=web.DHCBL.MKB.MKBTermProperty&QueryName=GetConfigDescList&ResultSetType=array&rowid="+row.MKBTPRowId
							/*formatter: function (row) { //formatter方法就是实现了在每个下拉选项前面增加checkbox框的方法  								
								var opts = $(this).combobox('options');  
								return '<label class="eaitor-label"><input class="eaitor-radio" type="radio"><span></span></label>' + row[opts.textField]  
							},
							onLoadSuccess: function () {  //下拉框数据加载成功调用  
						        var opts = $(this).combobox('options');  
						        var target = this;  
						        var record= $("#mygridProperty").datagrid('getSelected');  
						        var values =record.MKBTPDDesc;
						       // alert(values)
						        if(values==undefined){
						            return
						        }
						        var el = opts.finder.getEl(target, values);  
						        el.find('input.eaitor-radio')._propAttr('checked', true);   
						       
						    },  
						    onSelect: function (row) { //选中一个选项时调用  
						        var opts = $(this).combobox('options');
						        //设置选中值所对应的复选框为选中状态  
						        var el = opts.finder.getEl(this, row[opts.valueField]); 
						        el.parent().find('input.eaitor-radio').each(function(){
						            $(this)._propAttr('checked', false)
						        });  
						        el.find('input.eaitor-radio')._propAttr('checked', true);  
						    }*/	
						}
		             }
		         });
		         
		     }else if(row.MKBTPType == 'CB'){
				var configInfos=tkMakeServerCall('web.DHCBL.MKB.MKBTermProperty','GetConfigDesc',row.MKBTPRowId);
				var configs = configInfos.split("&%"); 
				var storeData=new Array()
				for (var j = 0; j <configs.length; j++) {
					var data={};  
					data["ConfigNum"]=configs[j];  
					data["ConfigName"]=configs[j];  
					storeData.push(data)	
				}

				$("#mygridProperty").datagrid('addEditor', {
		             field : 'MKBTPDDesc',
		             editor : {
		                 type:'combobox',
						 options:{
							//url:$URL+"?ClassName=web.DHCBL.MKB.MKBTermProperty&QueryName=GetConfigDescList&ResultSetType=array&rowid="+row.MKBTPRowId,
							rowStyle:"checkbox",
							multiple:true,
							panelHeight: 'auto',
							selectOnNavigation:false,
							editable:false,
							valueField:'ConfigNum',
							textField:'ConfigName',
							data:storeData
							/*formatter: function (row) { //formatter方法就是实现了在每个下拉选项前面增加checkbox框的方法  
                				var opts = $(this).combobox('options');  
                				//return '<label class="eaitor-label"><input class="eaitor-checkbox" type="checkbox"><span></span></label>' + row[opts.textField]  
                    			return '<label class="eaitor-label"><input class="eaitor-checkbox" type="checkbox"><span value="'+row[opts.valueField] +'"></span></label>' + row[opts.textField]  
                				
            				},
            				onLoadSuccess: function () {  //下拉框数据加载成功调用  
			                    var opts = $(this).combobox('options');  
			                    var target = this;  
			                    var record= $("#mygridProperty").datagrid('getSelected');
			                    if(record.MKBTPDDesc==undefined){
				                    return
				                }
			                    var values =record.MKBTPDDesc.split(',');
			                    //console.log(values); 
			                    $.map(values, function (value) {  
			                    	 var el = opts.finder.getEl(target, value);  
				                     el.find('input.eaitor-checkbox')._propAttr('checked', true);   
			                    }) 
			                    var opts = $(this).combobox('options'); 
			                    var target = this; 
			                    $('.eaitor-label span').each(function(){
				                    $(this).click(function(){
					                    if($(this).prev()._propAttr('checked')){
						                    $(target).combobox('unselect',$(this).attr('value'));

						                }
						                else{
							                $(target).combobox('select',$(this).attr('value'));
							            }
					                })
				                });   
			                    var record=$("#mygridProperty").datagrid('getSelected');
			                    if(record.MKBTPDDesc==undefined){
				                    return
				                }
			                    var values =record.MKBTPDDesc.split(',');
			                    $.map(values, function (value) {  
			                        var el = opts.finder.getEl(target, value);  
			                        el.find('input.eaitor-checkbox')._propAttr('checked', true);
			                    }) 
			                },  
			                onSelect: function (row) { //选中一个选项时调用  
			                    var opts = $(this).combobox('options');  
			                    //设置选中值所对应的复选框为选中状态  
			                    var el = opts.finder.getEl(this, row[opts.valueField]); 
			                    //console.log(el);  
			                    el.find('input.eaitor-checkbox')._propAttr('checked', true);
			                    
			                },  
			                onUnselect: function (row) {//不选中一个选项时调用  
			                    var opts = $(this).combobox('options');  
			                    var el = opts.finder.getEl(this, row[opts.valueField]);  
			                    el.find('input.eaitor-checkbox')._propAttr('checked', false);  
			                }*/
						}
		             }
		         });
		     }else if(row.MKBTPType == 'C'){
		         $("#mygridProperty").datagrid('addEditor', {
		             field : 'MKBTPDDesc',
		             editor : {
		                 type:'combobox',
						options:{
							valueField:'ConfigNum',
							textField:'ConfigName',
							//panelHeight: 'auto',
							url:$URL+"?ClassName=web.DHCBL.MKB.MKBTermProperty&QueryName=GetConfigDescList&ResultSetType=array&rowid="+row.MKBTPRowId,
							formatter:function(value){
						  	var rtn="";
					  		if(value!=null){
					  			rtn=value.ConfigName
					  			//rtn=tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetConfigName",row.MKBTPRowId,value.ConfigNum);
					  		}
					  		return rtn
						}
							
						}
		             }
		         });
		     }
		     else if(row.MKBTPType == 'SS'){
		     	ssbasetype= tkMakeServerCall("web.DHCBL.MKB.MKBTerm", "GetBaseTypeByID",row.MKBTPConfig)
		     	if (ssbasetype="T"){
			         $("#mygridProperty").datagrid('addEditor', {
			             field : 'MKBTPDDesc',
			             editor : {
			                 type:'combotree',
							 options:{
								valueField:'MKBTRowId',
								textField:'MKBTDesc',
								onShowPanel:function(){		
									var opts = $(this).combotree('options')
									var url="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmb&base="+row.MKBTPConfig
					         		if (opts)
					         		{
					         			$(this).combotree('reload',url);
					         		}
					         	},
								onHidePanel:function(){
					         		var target=$(this)
									if($(this).combo('getText')==""){
										$(this).combo('setValue',"")
									}
								}
							}
			             }
			         });
		     	}
		     	else
		     	{
		     		 $("#mygridProperty").datagrid('addEditor', {
			             field : 'MKBTPDDesc',
			             editor : {
			                 type:'combobox',
							 options:{
								valueField:'MKBTRowId',
								textField:'MKBTDesc',
								//panelHeight: 'auto',
								url:$URL+"?ClassName=web.DHCBL.MKB.MKBTerm&QueryName=GetDataForCmb1&ResultSetType=array&base="+row.MKBTPConfig,
								formatter:function(value){
							  	var rtn="";
						  		if(value!=null){
						  			rtn=value.MKBTDesc
						  			//rtn=tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetConfigName",row.MKBTPRowId,value.ConfigNum);
						  		}
						  		return rtn
							}
								
							}
			             }
			         });
		     	}
		     }
         },
		toolbar:'#mytbarProperty'
	});
	ShowUserHabit('mygridProperty');
	PropertyAfterEdit=function(index, row)
	{
		if ((index==-1)||(row==undefined))  return;
		
		var MKBTPRowId=row.MKBTPRowId;//属性id 
			if(MKBTPRowId==""){  
		        $.messager.alert('提示', '没有获取到该属性！');  
		        $("#mygridProperty").datagrid('reload');  
		        return;  
		    }
		    
		    var MKBTPDesc=row.MKBTPDesc;//属性名称  
		    if(MKBTPDesc==""){  
		        $.messager.alert('提示', '属性名称不能为空！');  
		        $("#mygridProperty").datagrid('reload');  
		        return;  
		    } 
		    //判断数据是否有变化
			var olddata=tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","OpenData",row.MKBTPRowId);
			olddata=olddata.replace(/\r\n/g,"\\n");    
        	olddata=olddata.replace(/\n/g,"\\n"); 
			var olddatajson=eval('(' + olddata + ')');
			var differentflag=1
			if((olddata.MKBTPDesc==row.MKBTPDesc)&&(olddata.MKBTPDDesc==row.MKBTPDDescF))
			{
				var differentflag=0
			}
			if (differentflag==0) {  
			    proeditIndex = "";
			    if (row.MKBTPType=="SD"){
				    //加载属性内容
					$('#mygridProperty').datagrid('reload');  // 重新载入当前页面数据 
				}
				    $('#mygridProperty').datagrid('unselectAll');  
			} 
			else 
			{  
			    if ((row.MKBTPType=="SD")&&(row.MKBTPDDesc!="")){
			    	MKBTPDDesc=row.MKBTPDDescF	
			    }
			    else
			    {
			    	MKBTPDDesc=row.MKBTPDDesc	
			    }
			    $.m({
						ClassName:"web.DHCBL.MKB.MKBTermProperty",
						MethodName:"UpdateProperty",
						RowId:row.MKBTPRowId,
						MKBTPDesc:row.MKBTPDesc,	
						MKBTPDDesc:MKBTPDDesc
					},function (data) { 
						  var data=eval('('+data+')'); 
						  if (data.success == 'true') {
						  		$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
								proeditIndex=undefined
								prorowsvalue=undefined
								
								//如果是中心词等或者显示在左侧列表的项刷新术语界面该条数据
						  		var leftreshflag=0
						  		if ((extendTitle!="")&&(extendTitle.indexOf(row.MKBTPDesc)!=-1))
						  		{
						  			var colsHead = extendTitle.split("[N]"); 
									for (var i = 0; i <extendTitle.length; i++) {
										if (colsHead[i]==row.MKBTPDesc)
										{
											leftreshflag=1
										}
									}
						  		}
						  		
								if ((row.MKBTPRowId.indexOf("MKBT")!=-1)&&(leftreshflag==1))
								{
									
									if(basetype=="T")
									{
										var record=$("#mygrid").treegrid('getSelected')
										var parentNode = $("#mygrid").treegrid('getParent',record.MKBTRowId)
										SaveProTermID=record.MKBTRowId
										if(parentNode)
										{
											ReloadTreegridNode("mygrid",parentNode.id,record.MKBTRowId)
										}
										else
										{
											$("#mygrid").treegrid('reload')
										}
										setTimeout(function(){
											$("#mygrid").treegrid('select',record.MKBTRowId)
											},500)
									}
									else
									{
										var record=$("#mygrid").datagrid('getSelected')
										SaveProTermID=record.MKBTRowId
										$('#mygrid').datagrid('reload');
										setTimeout(function(){
											$('#mygrid').datagrid('selectRecord',record.MKBTRowId)
											
											},500)
									}
								}
								
								$('#mygridProperty').datagrid('reload');  // 重新载入当前页面数据
						  } 
						  else { 
								var errorMsg ="提交失败！"
								if (data.errorinfo) {
									errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
								}
								proeditIndex=undefined
								$.messager.alert('操作提示',errorMsg,"error");
						}
						
				} );  
			} 
	}
	//是否有正在编辑的行true/false
	function proendEditing(){
		if (proeditIndex == undefined){return true}
		if ($('#mygridProperty').datagrid('validateRow', proeditIndex)){
			$('#mygridProperty').datagrid('endEdit', proeditIndex);
			prorowsvalue=$('#mygridProperty').datagrid('getRows')[proeditIndex];
			//proeditIndex = undefined;
			return true;
		} else {
			return false;
		}
	}  

	$(document).bind('click',function(){ 
		if(proendEditing())
		{
			var index=$('#mygridProperty').datagrid('getRowIndex',prorowsvalue);
	    	PropertyAfterEdit(index,prorowsvalue)
		}
	}); 
	
	//多行文本框
	function Creatdom(jq1,jq2){
			var target=$(jq1).find('td[field='+jq2+'] textarea')
			//console.log(target)
			target.click(function(){
				$('body').append('<textarea rows="10" cols="30" id="textareadom" style="z-index:999999;display:none;position:absolute;background:#FFFFFF">')
				$("#textareadom").val(target.val())
				if(target.offset().top+$("#textareadom").height()>$(window).height()){
					$("#textareadom").css({
	                    "left": target.offset().left,
	                    "top": target.offset().top-$("#textareadom").height()+27,
	                    "width":target.width()
	                }).show();
				}
				else{
					$("#textareadom").css({
	                    "left": target.offset().left,
	                    "top": target.offset().top,
	                    "width":target.width()
	                }).show();
				}
                $("#textareadom").focus().blur(function(){
	                target.val($("#textareadom").val())	
					$(this).remove();
				}).keydown(function(e){
						if(e.keyCode==13){
							//$("#textareadom").hide();
   							target.val($("#textareadom").val())	
						}
					});
			});
			
		}
	//知识表达式
	function Creatdom2(jq1,jq2,sdbasedr){
		var target=$(jq1).find('td[field='+jq2+'] input')
		var targetf=$(jq1).find('td[field='+jq2+'F] input')
		//MKBTPDDescF
		//MKBTPDDesc
		detailstr[jq2]=targetf.val();
		//console.log(detailstr)
		//$('body').append(' <div id="baseiframe"><iframe id="upload" src="../csp/dhc.bdp.mkb.mkbknoexpression.csp'+'?base='+base+'?str='+str+' frameborder="0" width="100%" height="100%" scrolling="no"></iframe></div>')
		target.click(function(){
			
			loadData(detailstr[jq2],sdbasedr,jq2,$(this))
			if(target.offset().top+$("#knoExe").height()+35>$(window).height()){
				$("#knoExe").css({
					"top": target.offset().top-$("#knoExe").height()-25
				});
			}
			else{
				$("#knoExe").css({
					"top": target.offset().top+30
				});
			}
			if($(window).width()-target.offset().left<$("#knoExe").width()){
				$("#knoExe").css({
					"left": $(window).width()-$("#knoExe").width()
				}).show();

			}
			else{
				$("#knoExe").css({
					"left": target.offset().left
				}).show();
			}	
			$("#read_btn").unbind('click').click(function(){
				document.getElementById("myWinProperty").style.display = 'none';				
				addBase(sdbasedr,jq2)	
				$("#knoExe").unbind('hide').hide("normal",function(){
					targetf.val(detailstr[jq2])
					var detail=tkMakeServerCall('web.DHCBL.MKB.MKBKnoExpression','GetDiagDesc',detailstr[jq2])
					target.val(detail)
				})
			});
			$(".knowledgeclass").next().find("input").focus();
		});
		
	}
		
	//扩展可编辑表格
	  $(function(){
     	 $.extend($.fn.datagrid.methods, {
           addEditor : function(jq, param) {
               if (param instanceof Array) {
                   $.each(param, function(index, item) {
                       var e = $(jq).datagrid('getColumnOption', item.field);
                       e.editor = item.editor;
                   });
              } else {
                  var e = $(jq).datagrid('getColumnOption', param.field);
                  e.editor = param.editor;
                 // console.log("param.editor->" + param.editor.type);
              }
          },
         removeEditor : function(jq, param) {
              if (param instanceof Array) {
                 $.each(param, function(index, item) {
                     var e = $(jq).datagrid('getColumnOption', item);
                     e.editor = {};
                 });
             } else {
                 var e = $(jq).datagrid('getColumnOption', param);
                 e.editor = {};
             }
         }
     });
	})
/** *****************************************诊断属性内容模块结束************************************************************************************** */
	//范文凯全文词表界面所需接口，多层嵌套iframe时，获取属性内容的id
	getMKBTPDRowId = function(){
	    var data = $("#i"+ProId)[0].contentWindow.getMKBTPDRowId();
	    return data;
	};
	
  
};
$(init);
