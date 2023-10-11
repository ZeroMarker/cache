/// 名称: 医用知识库管理-知识库注册
/// 描述: 包含知识库、知识库属性、知识库扩展属性维护
/// 编写者: 基础数据平台组-高姗姗
/// 编写日期: 2018-03-27

var init = function(){
	/*--------------知识库维护类方法的URL-------------------*/
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBTermBase&pClassMethod=SaveEntity&pEntityName=web.Entity.MKB.MKBTermBase";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermBase&pClassMethod=DeleteData";
	/*--------------知识库属性维护类方法的URL-------------------*/
	var PROPERTY_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBTermBaseProperty&pClassMethod=SaveEntity&pEntityName=web.Entity.MKB.MKBTermBaseProperty";
	var PROPERTY_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermBaseProperty&pClassMethod=DeleteData";
	/*--------------知识库扩展属性维护类方法的URL-------------------*/
	var EXTENDPRO_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBTermBaseExtendPro&pClassMethod=SaveEntity&pEntityName=web.Entity.MKB.MKBTermBaseExtendPro";
	var EXTENDPRO_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermBaseExtendPro&pClassMethod=DeleteData";
	
	var basedr = ""; //知识库id
	var propertyid=""; //知识库属性选中行的属性id
	var propertyresid=""; //知识库属性保存过后返回的属性id
	var indexExtendProConfig=""; 
	var indexPropertyConfig="";
	/******************************************知识库维护开始***********************************************************************************************/
	var basecat = tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetIdByFlag","Cat")
	$HUI.tree('#catTree',{
		url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermBase&pClassMethod=GetCatJsonData&base="+basecat,
		lines:true,  //树节点之间显示线条
		autoSizeColumn:false,
		checkbox:true,
		cascadeCheck:false,  //是否级联检查。默认true  菜单特殊，不级联操作
		animate:false,   //是否树展开折叠的动画效果
		onClick:function(node){
			if (node.checked){
				$('#catTree').tree('uncheck',node.target)  
			}else{
				$('#catTree').tree('check',node.target)  
			}
		},
		onLoadSuccess:function(){
        	var catStr=$("#MKBTBCatDr").val();
        	if (catStr!=""){
	        	var array = catStr.split('&%')
				for(var i=0;i<array.length;i++){
					var node= $('#catTree').tree('find',array[i])
					$('#catTree').tree('check',node.target)  
				}
        	}
		}
	});
	//知识库分类检索框
	$("#catWin").keyup(function(){ 
		var str = $("#FindTreeText").val(); 
		findByRadioCheck("catTree",str,$("input[name='FilterCK']:checked").val())
		
	})
	///知识库分类全部、已选、未选
	$HUI.radio("#catWin [name='FilterCK']",{
        onChecked:function(e,value){
        	findByRadioCheck("catTree",$("#FindTreeText").val(),$(e.target).attr("value"))
       }
    });
	//知识库维护知识库分类
	 $("#btnCat").click(function (e) { 
	 	$("#catWin").show();
	 	$("#catTree").tree("reload")  //窗口每次打开时，数据重新加载
		$HUI.radio("#myChecktreeFilterCK0").setValue(true)  //初始设置为全部
		$("#FindTreeText").val("")
		var catWin = $HUI.dialog("#catWin",{
			resizable:true,
			title:'知识库分类',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				//iconCls:'icon-save',
				id:'save_tree_btn',
				handler:function(){
					var strCatId = "",strCatText = "";
					var nodes = $('#catTree').tree('getChecked');
	                for (var i = 0; i < nodes.length; i++) {
	                   if (strCatId!="") strCatId=strCatId+"&%"+nodes[i].id;
						else strCatId=nodes[i].id
						if (strCatText!="") strCatText=strCatText+","+nodes[i].text;
						else strCatText=nodes[i].text
	                }
					$("#MKBTBCatDr").val(strCatId)
					$("#MKBTDesc").val(strCatText)
			 		/*if ($("#MKBTBDesc").val()==""){
			 			//知识库名为空时，根据分类自动生成前缀
			 			$("#MKBTBDesc").val(strCatText+"_")
			 		}else{
			 			//知识库名不为空时，根据分类自动修改前缀
			 			if ($("#MKBTBDesc").val().indexOf("_")>=0){
			 				var newValue=$("#MKBTBDesc").val().replace($("#MKBTBDesc").val().split("_")[0],strCatText)
			 				$("#MKBTBDesc").val(newValue)
			 			}
			 		}*/
					catWin.close();
				}
			},{
				text:'关闭',
				//iconCls:'icon-cancel',
				handler:function(){
					catWin.close();
				}
			}]
		});	
	 });
	 
	 //知识库名失去焦点自动生成检索码
	  $('#MKBTBDesc').bind('blur',function(){
           $("#MKBTBPYCode").val(Pinyin.GetJPU($('#MKBTBDesc').val()))
           if($("#MKBTBCodeRules").is(':disabled'))
			{
			}
			else
			{
				 $("#MKBTBCodeRules").val(Pinyin.GetJPU($('#MKBTBDesc').val()))
		    }
      });     
	//检索码失去焦点自动生成编码规则
	  $('#MKBTBPYCode').bind('blur',function(){
	  	if($("#MKBTBCodeRules").is(':disabled'))
		{
		}
		else
		{
			 $("#MKBTBCodeRules").val(Pinyin.GetJPU($('#MKBTBDesc').val()))
	    }
          
      }); 
	//知识库维护弹窗标识下拉框
	$HUI.combobox("#MKBTBFlag",{
		valueField:'value',
		textField:'text',
		data:[
			{value:'Diagnose',text:'诊断'},
			{value:'Drug',text:'药品'},
			{value:'Lab',text:'检验'},
			{value:'Check',text:'检查'},	
			{value:'Operation',text:'手术'},	
			{value:'Cat',text:'分类'},
			{value:'Part',text:'部位'},
			{value:'Pathogeny',text:'病因'},	
			{value:'GenDesc',text:'通用描述'},
			{value:'Loc',text:'科室'},
			{value:'ICD10Inter',text:'ICD10国际码'},	
			{value:'ICD10BJ',text:'ICD10北京码'},
			{value:'DiagMark',text:'诊断标记'},
			{value:'ICD11',text:'ICD11'},
			{value:'DiagModifi',text:'诊断修饰'},
			{value:'KnoClass',text:'知识分级'},
			{value:'DiaType',text:'诊断类型'},
			{value:'DiaState',text:'诊断状态'},
			{value:'TCMDiag',text:'中医诊断'}
			
	]
	});
	//知识库维护弹窗类型下拉框
	$HUI.combobox("#MKBTBType",{
		valueField:'value',
		textField:'text',
		data:[
			{value:'L',text:'列表'},
			{value:'T',text:'树形'}
		]
	});
	var url="dhc.bdp.loadpicture.csp"
	if ('undefined'!==typeof websys_getMWToken){
		url += "?MWToken="+websys_getMWToken()
	}
	//知识库维护更改图标
	 $("#DataLiftBtn").click(function (e) { 
		$("#imageWin").show();
		var imageWin = $HUI.dialog("#imageWin",{
			resizable:true,
			title:'选择图标',
			modal:true,
			
			content:'<iframe id="timeline" src="'+url+'" width="99%" height="98%" scrolling="no"></iframe>',
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				//iconCls:'icon-save',
				id:'ok_btn',
				style:'text-align: center;',
				handler:function(){
					var topWin =document.getElementById("timeline").contentWindow;
                    var ImageValue=topWin.document.getElementById("pictureinput").value;
                    $('#Image').attr('src',ImageValue);
                    $("#MKBTBImage").val(ImageValue)
                    imageWin.close();
				}
			},{
				text:'关闭',
				//iconCls:'icon-cancel',
				handler:function(){
					imageWin.close();
				}
			}],
			onClose:function(){ 
	           var topWin =document.getElementById("timeline").contentWindow;
               topWin.document.getElementById("imagesee").src="../../../dthealth/web/scripts/bdp/Framework/BdpIconsLib/null.png";
	       }
		});	
	 })  
	//知识库维护清除图标
	 $("#cancelbtn").click(function (e) { 
	 		$('#Image').attr('src',"../../../dthealth/web/scripts/bdp/Framework/BdpIconsLib/null.png");
            $("#MKBTBImage").val("")
	 })  
	 
	 //知识库维护查询框
	 $('#TextSearchBase').searchcombobox({ 
		url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+"User.MKBTermBase",
		onSelect:function () 
		{	
			$(this).combobox('textbox').focus();
			SearchFunLib()  
        }
	});
	$('#TextSearchBase').combobox('textbox').bind('keyup',function(e){  
		if (e.keyCode==13){ 
			SearchFunLib()  
		}
    }); 
    
    $("#btnSearch").click(function (e) { 
			SearchFunLib();
	}) 


	 
	//知识库维护重置按钮
	$("#btnRefresh").click(function (e) { 
			ClearFunLib();
	 }) 
	 //知识库维护新增按钮
	$("#btnAdd").click(function (e) { 
			AddData();
	 }) 
	 
	 //知识库维护修改按钮
	$("#btnUpdate").click(function (e) { 
			UpdateData();
	 }) 
	 
	 //知识库维护删除按钮
	$("#btnDel").click(function (e) { 
			DelData();
	 }) 
	 
	 //知识库维护查询方法
	SearchFunLib=function (){
		//ableTbProperty(false);
		//是否显示图片
	 	IsShowImg("")
		var desc=$("#TextSearchBase").combobox('getText')
		//var desc=$.trim($("#btnSearch").searchbox('getValue'));
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.MKB.MKBTermBase",
			QueryName:"GetList",
			'desc':desc
		});
		$('#mygrid').datagrid('unselectAll');
		//知识库属性重置
		//$("#btnSearchProperty").searchbox('setValue', '');
		/*$("#TextSearchProperty").combobox('setValue', '');
		$('#mygridProperty').datagrid('load',  { 
			ClassName:"web.DHCBL.MKB.MKBTermBaseProperty",
			QueryName:"GetList",
			'basedr': ""
		});
		$('#mygridProperty').datagrid('unselectAll');*/
	}
	
	//知识库维护重置方法
	ClearFunLib=function ()
	{
		//ableTbProperty(false);
		//是否显示图片
	 	IsShowImg("")
		//$("#btnSearch").searchbox('setValue', '');
		$("#TextSearchBase").combobox('setValue', '');
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.MKB.MKBTermBase",
			QueryName:"GetList",
			'desc':""
		});
		$('#mygrid').datagrid('unselectAll');
		//知识库属性重置
		//$("#btnSearchProperty").searchbox('setValue', '');
		/*$("#TextSearchProperty").combobox('setValue', '');
		$('#mygridProperty').datagrid('load',  { 
			ClassName:"web.DHCBL.MKB.MKBTermBaseProperty",
			QueryName:"GetList",
			'basedr': ""
		});
		$('#mygridProperty').datagrid('unselectAll');*/
	}
	
	//知识库维护新增按钮
	AddData=function() {
		$("#myWin").show();
		var myWin = $HUI.dialog("#myWin",{
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
		
		//知识库分类是否必填判断
		var CatExistFlag=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetCatExist");
		if (CatExistFlag=="1"){
			document.getElementById('tdCat').innerHTML="<font color=red>*</font>知识库分类"
			$("#MKBTDesc").validatebox({required:true,tipPosition:"top"})
		}else{
			document.getElementById('tdCat').innerHTML="知识库分类"
			$("#MKBTDesc").validatebox({required:false})
		}
		
		$('#form-save').form("clear");
		//知识库ID自动生成
		var code = tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetLastCode");
		$("#MKBTBCode").val(code);
		//图标清空
		$('#Image').attr('src',"../../../dthealth/web/scripts/bdp/Framework/BdpIconsLib/null.png");
		//菜单顺序自动生成
		var LastSequence=parseInt(tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetLastSequence"));
		$("#MKBTBSequence").val(LastSequence+1)
		//编码规则可编辑
		$('#MKBTBCodeRules').removeAttr('disabled')
		
	}
	
	//知识库维护修改按钮
	UpdateData=function() {
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		
		var id=record.MKBTBRowId
		$.cm({
			ClassName:"web.DHCBL.MKB.MKBTermBase",
			MethodName:"OpenData",
			RowId:id
		},function(jsonData){
			$('#form-save').form("load",jsonData);	
			var flag=parseInt(tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","IsCodeRulesChange",jsonData.MKBTBRowId))
			if (flag==1)
			{
				$('#MKBTBCodeRules').attr('disabled','disabled')
			}
			else
			{
				$('#MKBTBCodeRules').removeAttr('disabled')
			}
		});
		$("#myWin").show(); 
		//知识库分类是否必填判断
		var CatExistFlag=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetCatExist");
		if (CatExistFlag=="1"){
			document.getElementById('tdCat').innerHTML="<font color=red>*</font>知识库分类"
			$("#MKBTDesc").validatebox({required:true,tipPosition:"top"})
		}else{
			document.getElementById('tdCat').innerHTML="知识库分类"
			$("#MKBTDesc").validatebox({required:false})
		}
		//图标赋值
		var ImageValue=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetIconByCode",record.MKBTBCode);
        $('#Image').attr('src',ImageValue);
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-edit',
			resizable:true,
			title:'修改',
			modal:true,
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
	}

	///知识库维护新增、更新
	SaveFunLib=function(id)
	{		
		var CatExistFlag=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetCatExist");
		if (CatExistFlag=="1"){
			if ($.trim($("#MKBTDesc").val())=="")
			{
				$.messager.alert('错误提示','知识库分类不能为空!',"error");
				return;
			}
		}
		var desc=$.trim($("#MKBTBDesc").val())
		if (desc=="")
		{
			$.messager.alert('错误提示','知识库名不能为空!',"error");
			return;
		}
		if (desc.length>100)
		{
			$.messager.alert('错误提示','知识库名长度不能超过100!',"error");
			return;
		}
		if ($.trim($("#MKBTBCodeRules").val())=="")
		{
			$.messager.alert('错误提示','编码规则不能为空!',"error");
			return;
		}
		if (($('#MKBTBType').combobox('getValue')=="")||($('#MKBTBType').combobox('getValue')==undefined))
		{
			$.messager.alert('错误提示','类型不能为空!',"error");
			return;
		}
		if ($('#MKBTBFlag').combobox('getValue')!=""){ //判断标识
			var flag = tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","ValidateFlag",id,$('#MKBTBFlag').combobox('getValue'));
			if (flag==1){
				$.messager.alert('错误提示','已经存在此标识的知识库!',"error");
				return;
			}
		}
		$('#form-save').form('submit', { 
			url: SAVE_ACTION_URL, 
			onSubmit: function(param){
				param.MKBTBRowId = id;
				param.MKBTBImage = $("#MKBTBImage").val();
				param.MKBTBCodeRules = $("#MKBTBCodeRules").val();
			},
			success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
				  		$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
						$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
						$('#myWin').dialog('close'); // close a dialog
				  } else { 
						var errorMsg ="提交失败！"
						if (data.errorinfo) {
							errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
						}
						$.messager.alert('操作提示',errorMsg,"error");
				  }
			} 
		});
	}
	//弹出加载层
	function loadMask() {  
	    $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: $(window).height() }).appendTo("body");  
	    $("<div class=\"datagrid-mask-msg\"></div>").html("数据删除中，请稍候...").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(window).height() - 45) / 2 });  
	}
	//移除加载层  
	function removeMask() {  
	    $(".datagrid-mask").remove();  
	    $(".datagrid-mask-msg").remove();  
	}
	///知识库维护删除按钮
	DelData=function()
	{                  
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var flagMenu=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetMenuExist",record.MKBTBCode);
		if (flagMenu==1){
			var deltip="删除所选数据会同时删除知识库属性、<br/>相应知识库菜单及其数据,<br/>确定要删除所选的数据吗?"
		}else{
			var deltip="删除所选数据会同时删除知识库属性,<br/>确定要删除所选的数据吗?"
		}
		$.messager.confirm('提示', deltip, function(r){
			if (r){	
				$.ajax({
					url:DELETE_ACTION_URL,  
					data:{
						"id":record.MKBTBRowId      ///rowid
					},  
					type:"POST",   
					beforeSend: function () {
						loadMask();
					},
					complete: function () {
					    removeMask();
					},
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
							  		$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
									RefreshSearchData("User.MKBTermBase",record.MKBTBRowId,"D","")
									$('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
									$('#mygrid').datagrid('unselectAll');  // 清空列表选中数据
									$('#mygridProperty').datagrid('reload');  // 重新载入当前页面数据  
									$('#mygridProperty').datagrid('unselectAll');  // 清空列表选中数据
							  } 
							  else { 
									var errorMsg ="删除失败！"
									if (data.info) {
										errorMsg =errorMsg+ '</br></br>错误信息:' + data.info
									}
									$.messager.alert('操作提示',errorMsg,"error");
							}			
					}  
				})
			}
		});
	}
	//知识库维护列
	var columns =[[  
				  {field:'MKBTBRowId',title:'MKBTBRowId',width:80,sortable:true,hidden:true},
				  {field:'MKBTBCode',title:'知识库ID',width:80,sortable:true,hidden:true},
				  {field:'MKBTBDesc',title:'知识库名',width:80,sortable:true,
				  	formatter:function(value,row,index){  
						//鼠标悬浮显示备注信息
						return '<span class="easyui-tooltip" title="'+row.MKBTBNote+'">'+value+'</span>'
					}},
				  {field:'MKBTBCatDr',title:'分类Id',width:80,sortable:true,hidden:true},
				  {field:'MKBTDesc',title:'分类',width:80,sortable:true},
				  {field:'MKBTBType',title:'类型',width:80,sortable:true,
				  	formatter:function(value,row,index){  
						if(value=="L"){
							return "列表";
						}
						if(value=="T"){
							return "树形";
						}
					}},
				  {field:'MKBTBFlag',title:'标识',width:80,sortable:true,
			  		formatter:function(value,row,index){  
							if(value=="Diagnose"){
								return "诊断";
							}
							if(value=="Drug"){
								return "药品";
							}
							if(value=="Lab"){
								return "检验";
							}
							if(value=="Check"){
								return "检查";
							}
							if(value=="Operation"){
								return "手术";
							}
							if(value=="Cat"){
								return "分类";
							}
							if(value=="Part"){
								return "部位";
							}
							if(value=="Pathogeny"){
								return "病因";
							}
							if(value=="GenDesc"){
								return "通用描述";
							}
							if(value=="Loc"){
								return "科室";
							}
							if(value=="ICD10Inter"){
								return "ICD10国际码";
							}
							if(value=="ICD10BJ"){
								return "ICD10北京码";
							}
							if(value=="DiagMark"){
								return "诊断标记";
							}
							if(value=="ICD11"){
								return "ICD11";
							}
							if(value=="DiagModifi"){
								return "诊断修饰";
							}
							if(value=="KnoClass"){
								return "知识分级";
							}
							if(value=="DiaType"){
								return "诊断类型";
							}
							if(value=="DiaState"){
								return "诊断状态";
							}
							if(value=="TCMDiag"){
								return "中医诊断";
							}
						}},
					{field:'MKBTBVersion',title:'版本',width:80,sortable:true,hidden:true},
					{field:'MKBTBSource',title:'出处',width:80,sortable:true,hidden:true},
					{field:'MKBTBPYCode',title:'拼音检索码',width:80,sortable:true},
					{field:'MKBTBCodeRules',title:'编码规则',width:80,sortable:true,hidden:true},
					{field:'MKBTBSequence',title:'菜单顺序',width:80,sortable:true,hidden:true},
					{field:'MKBTBNote',title:'备注',width:80,sortable:true,hidden:true}
				  ]]
				 
	//知识库维护列表
	var isdblclick;
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.MKB.MKBTermBase",         ///调用Query时
			QueryName:"GetList"
		},
		ClassTableName:'User.MKBTermBase',
		SQLTableName:'MKB_TermBase',
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		idField:'MKBTBRowId', 
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		resizable:true,
		fixed:true,
		remoteSort:false,  //定义是否从服务器排序数据。true
		toolbar:'#mytbar',
		onLoadSuccess:function(data){
			if (basedr==""){
				//ableTbProperty(false);
				//是否显示图片
	 			IsShowImg("")
			}
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
			$(this).datagrid('columnMoving');
			//检索框不为空时，选中第一条
        	var searchvalue=$('#TextSearchBase').combobox('getText');
			if(searchvalue!="")
			{
				if (data.total!=0)
				{
					$('#mygrid').datagrid('selectRow',0);
					var rowData=$('#mygrid').datagrid('getSelected')
					if (rowData!=undefined)
					{
						
						//是否显示图片
	 					IsShowImg(rowData)
				 		//ableTbProperty(true);
	 					/*basedr=rowData.MKBTBRowId
						$('#mygridProperty').datagrid('load',  { 
							ClassName:"web.DHCBL.MKB.MKBTermBaseProperty",
							QueryName:"GetList",
							'basedr':basedr
						});
						$("#TextSearchProperty").combobox('setValue', '');*/
					  }
			   }
			}
		},
		onClickRow:function(rowIndex,rowData){
			isdblclick=false;
			
			RefreshSearchData("User.MKBTermBase",rowData.MKBTBRowId,"A",rowData.MKBTBDesc)
	    	window.setTimeout(rowclickFn(rowData), 500);
	    	function rowclickFn(rowData){
	    		if(isdblclick!=false)return;
	    		//是否显示图片
	 			IsShowImg(rowData)
	    		//ableTbProperty(true);
	 			/*basedr=rowData.MKBTBRowId;
				$('#mygridProperty').datagrid('load',  { 
					ClassName:"web.DHCBL.MKB.MKBTermBaseProperty",
					QueryName:"GetList",
					'basedr':basedr
				});
				//$("#btnSearchProperty").searchbox('setValue', '');
				$("#TextSearchProperty").combobox('setValue', '');
				$('#mygridProperty').datagrid('unselectAll');*/
				
				/*$('#TextSearchProperty').searchcombobox({ 
					url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+"User.MKBTermBaseProperty"+basedr
				});*/
	    	}
		},
		onDblClickRow:function(rowIndex,rowData){
			isdblclick=true;
			
	    	window.setTimeout(rowclickFn(rowData), 500);
	    	function rowclickFn(rowData){
	    		if(isdblclick!=false)return;
	    		//是否显示图片
	 			IsShowImg(rowData)
				//ableTbProperty(true);
	 			/*basedr=rowData.MKBTBRowId;
				$('#mygridProperty').datagrid('load',  { 
					ClassName:"web.DHCBL.MKB.MKBTermBaseProperty",
					QueryName:"GetList",
					'basedr':basedr
				});
				//$("#btnSearchProperty").searchbox('setValue', '');
				$("#TextSearchProperty").combobox('setValue', '');
				$('#mygridProperty').datagrid('unselectAll');*/
	    	}
	    	
			var menuid=tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.mkb.mtm."+$("#mygrid").datagrid("getSelected").MKBTBCode);
			var parentid=tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.mkb.mtm");
			var menuimg=tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetIconByID",menuid);
			
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
	        if(!Sys.ie){
		        window.parent.showNavTab(menuid,$("#mygrid").datagrid("getSelected").MKBTBDesc,'dhc.bdp.ext.sys.csp?BDPMENU='+menuid,parentid,menuimg)
	        }else{
	        	parent.PopToTab(menuid,$("#mygrid").datagrid("getSelected").MKBTBDesc,'dhc.bdp.ext.sys.csp?BDPMENU='+menuid,menuimg);
	        }
        }
	});
	ShowUserHabit('mygrid');
	
	/******************************************知识库维护结束***********************************************************************************************/
	/*************************************************知识库扩展属性维护开始*****************************************************/
	//类型
	$HUI.combobox("#MKBTBEPType",{
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
	/**********************知识库扩展属性配置项开始*******************/
	var extendproid=""
	//知识库扩展属性配置项新增
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
	//知识库扩展属性配置项删除
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
						var saveFlag =tkMakeServerCall("web.DHCBL.MKB.MKBTermBaseExtendPro","DeleteConfig",extendproid,index);
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
	//知识库扩展属性清除配置项配置
	RemoveExtendConfigTool=function(){
		if ($("#trextendconfig").length>0){
			$("#trextendconfig").remove();
		}
		if ($("#trextendconfiggrid").length>0){
			$("#trextendconfiggrid").remove();
		}
	}
	//知识库扩展属性新增配置项配置
	AppendExtendConfigTool=function(type,extendproid,configJson){
		//引用术语配置项
		if (type=="S"){
			var configTool="<tr id='trextendconfig'><td align='right'><font color=red>*</font>配置项</td><td><input id='ExtendProConfig' name='ExtendProConfig' type='text' class='hisui-combobox'  style='width:200px' data-options='required:true'></td></tr>"
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
			var configTool="<tr id='trextendconfig'><td align='right'><font color=red>*</font>配置项</td><td><input id='ExtendProConfig' name='ExtendProConfig' type='text' class='hisui-combobox'  style='width:200px' data-options='required:true'></td></tr>"
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
			var targetConfigGrid=$("<tr id='trextendconfiggrid'><td colspan='2'><div id='mygridExtendProConfig' style='width:260px;height:300px'></div></td></tr>").appendTo("#form-save-ExtendPro table");
			$.parser.parse(targetConfigGrid);
			//知识库扩展属性可编辑配置项列表
			$("#mygridExtendProConfig").datagrid({
				/*url:$URL,
				queryParams:{
					ClassName:"web.DHCBL.MKB.MKBTermBaseExtendPro",         ///调用Query时
					QueryName:"GetConfigList",
					'rowid': extendproid
				},*/
				columns: [[  
				  {field:'ConfigNum',title:'ConfigNum',width:150,sortable:true,hidden:true},
				  {field:'ConfigName',title:'配置项名称',width:150,sortable:true,editor:{type:'validatebox'}}
				  ]],  //列信息
				pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
				pageSize:PageSizePop,
				pageList:[5,10,12,15,20,25,30,50,75,100,200,300,500,1000], 
				singleSelect:true,
				idField:'ConfigName', 
				rownumbers:true,    //设置为 true，则显示带有行号的列。
				fixRowNumber:true,
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
						ClassName:"web.DHCBL.MKB.MKBTermBaseExtendPro",         ///调用Query时
						QueryName:"GetConfigList",
						'rowid': extendproid
					}
				}); 
			}
			
			
		}
	}
	$("#MKBTBEPType").combobox({
		onSelect:function(record){
			RemoveExtendConfigTool();
			AppendExtendConfigTool(record.value);
		}
	});
	/**********************知识库扩展属性配置项结束**********************/
	//知识库扩展属性新增
	/*AddExtendPro=function(){
		if(indexExtendProConfig!==""){
	           $("#mygridExtendProConfig").datagrid('endEdit', indexExtendProConfig);
	        }
		var extendproName=$.trim($("#MKBTBEPName").val());
		if (extendproName=="")
		{
			$.messager.alert('错误提示','扩展属性名称不能为空!',"error");
			return;
		}
		if (($('#MKBTBEPType').combobox('getValue')=="")||($('#MKBTBEPType').combobox('getValue')=="undefined"))
		{
			$.messager.alert('错误提示','类型不能为空!',"error");
			return;
		}
	    //知识库扩展属性配置项赋值
		var configstr=""
		if (($('#MKBTBEPType').combobox('getValue')=="S")||($('#MKBTBEPType').combobox('getValue')=="SD")){
			configstr=$('#ExtendProConfig').combobox('getValue');
		}
		if (($('#MKBTBEPType').combobox('getValue')=="R")||($('#MKBTBEPType').combobox('getValue')=="CB")||($('#MKBTBEPType').combobox('getValue')=="C")){
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
				param.MKBTBEPParRef = parref;
				param.MKBTBEPRowId = "";
				param.MKBTBEPConfig = configstr;
			},
			success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
				  		$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
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
		$("#MKBTBEPType").combobox('setValue','TX');
	}*/
	//知识库扩展属性修改
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
        	var extendproName=$.trim($("#MKBTBEPName").val());
			if (extendproName=="")
			{
				$.messager.alert('错误提示','扩展属性名称不能为空!',"error");
				return;
			}
        	if (($('#MKBTBEPType').combobox('getValue')=="")||($('#MKBTBEPType').combobox('getValue')=="undefined"))
			{
				$.messager.alert('错误提示','类型不能为空!',"error");
				return;
			}
			 //知识库扩展属性配置项赋值
			var configstr=""
			if (($('#MKBTBEPType').combobox('getValue')=="S")||($('#MKBTBEPType').combobox('getValue')=="SD")){
				configstr=$('#ExtendProConfig').combobox('getValue');
			}
			if (($('#MKBTBEPType').combobox('getValue')=="R")||($('#MKBTBEPType').combobox('getValue')=="CB")||($('#MKBTBEPType').combobox('getValue')=="C")){
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
					param.MKBTBEPParRef = parref;
					param.MKBTBEPRowId = extendproid;
					param.MKBTBEPConfig = configstr;
				},
				success: function (data) { 
					  var data=eval('('+data+')'); 
					  if (data.success == 'true') {
					  		$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
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
			$("#MKBTBEPType").combobox('setValue','TX');
        }
	}*/
	//知识库扩展属性重置按钮
	$("#refresh_btn_ExtendPro").click(function (e) { 
		RefreshExtendPro();
	 }) 
	//知识库扩展属性新增按钮
	 $("#add_btn_ExtendPro").click(function (e) { 
		AddExtendPro();
	 }) 
	 //知识库扩展属性修改按钮
	 $("#update_btn_ExtendPro").click(function (e) { 
		UpdateExtendPro();
	 }) 
	//知识库扩展属性重置表单
	 RefreshExtendPro=function(){
	 	RemoveExtendConfigTool();
	 	$('#form-save-ExtendPro').form("clear");
		$("#MKBTBEPType").combobox('setValue','TX');
	   	$('#mygridExtendPro').datagrid('clearSelections');
	 }
	 //知识库扩展属性新增
	var k = 5;
	AddExtendPro=function(){
		if(indexExtendProConfig!==""){
           $("#mygridExtendProConfig").datagrid('endEdit', indexExtendProConfig);
        }
        var extendproname=$.trim($("#MKBTBEPName").val())
		if (extendproname=="")
		{
			$.messager.alert('错误提示','扩展属性名称不能为空!',"error");
			return;
		}
		//新增时扩展属性的重复校验
		var rows = $("#mygridExtendPro").datagrid("getRows"); //获取当前页的所有行
		for(var i=0;i<rows.length;i++)
		{
			if (rows[i].MKBTBEPName==extendproname){
				$.messager.alert('错误提示','该记录已存在!',"error");
				return;
			}
		}
    	if (($('#MKBTBEPType').combobox('getValue')=="")||($('#MKBTBEPType').combobox('getValue')=="undefined"))
		{
			$.messager.alert('错误提示','类型不能为空!',"error");
			return;
		}
		 //知识库扩展属性配置项赋值
		var configstr=""
		if (($('#MKBTBEPType').combobox('getValue')=="S")||($('#MKBTBEPType').combobox('getValue')=="SD")){
			configstr=$('#ExtendProConfig').combobox('getValue');
			if (configstr==""){
		    	$.messager.alert('错误提示','配置项不能为空!',"error");
  				return;
		    }
		}
		
		if (($('#MKBTBEPType').combobox('getValue')=="R")||($('#MKBTBEPType').combobox('getValue')=="CB")||($('#MKBTBEPType').combobox('getValue')=="C")){
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
		     MKBTBEPName : extendproname ,
		     MKBTBEPType : $('#MKBTBEPType').combobox('getValue'),
		     MKBTBEPConfig: configstr,
		     Id:k,
		     configJson:configJson
		}) 
		changeUpDownStatusEP();
		RefreshExtendPro();
	}
	//知识库扩展属性修改
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
        var extendproname=$.trim($("#MKBTBEPName").val())
		if (extendproname=="")
		{
			$.messager.alert('错误提示','扩展属性名称不能为空!',"error");
			return;
		}
		//修改时扩展属性的重复校验
		var rows = $("#mygridExtendPro").datagrid("getRows"); //获取当前页的所有行
		var selectId=record.Id;
		var selectExtendRowId=record.MKBTBEPRowId;
		for(var i=0;i<rows.length;i++)
		{
			if((selectId!="")&&(selectId!=undefined)){if(selectId==rows[i].Id) continue;}
			if((selectExtendRowId!="")&&(selectExtendRowId!=undefined)){if(selectExtendRowId==rows[i].MKBTBEPRowId) continue;}
			if (rows[i].MKBTBEPName==extendproname){
				$.messager.alert('错误提示','该记录已存在!',"error");
				return;
			}
		}
    	if (($('#MKBTBEPType').combobox('getValue')=="")||($('#MKBTBEPType').combobox('getValue')=="undefined"))
		{
			$.messager.alert('错误提示','类型不能为空!',"error");
			return;
		}
		 //知识库扩展属性配置项赋值
		var configstr=""
		if (($('#MKBTBEPType').combobox('getValue')=="S")||($('#MKBTBEPType').combobox('getValue')=="SD")){
			configstr=$('#ExtendProConfig').combobox('getValue');
			if (configstr==""){
		    	$.messager.alert('错误提示','配置项不能为空!',"error");
  				return;
		    }
		}
		if (($('#MKBTBEPType').combobox('getValue')=="R")||($('#MKBTBEPType').combobox('getValue')=="CB")||($('#MKBTBEPType').combobox('getValue')=="C")){
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
				 MKBTBEPName : extendproname ,
			     MKBTBEPType : $('#MKBTBEPType').combobox('getValue'),
			     MKBTBEPConfig: configstr,
			     flag:record.flag,
			     configJson:configJson
			}
		});
		changeUpDownStatusEP();
		RefreshExtendPro();
		if (record.flag=="main"){ //扩展属性列表中的主列名称不允许删除
			$('#btnDelExtendPro'+extendproname).addClass("disabled");
		}
	}
	//知识库扩展属性保存
/*	SaveExtendPro=function(){
		if(indexExtendProConfig!==""){
           $("#mygridExtendProConfig").datagrid('endEdit', indexExtendProConfig);
        }
        var record = $("#mygridExtendPro").datagrid("getSelected")
        if (!(record))
		{	
			extendproid=""
		}  else {
			extendproid=record.MKBTBEPRowId;
		}
    	var extendproName=$.trim($("#MKBTBEPName").val());
		if (extendproName=="")
		{
			$.messager.alert('错误提示','扩展属性名称不能为空!',"error");
			return;
		}
    	if (($('#MKBTBEPType').combobox('getValue')=="")||($('#MKBTBEPType').combobox('getValue')=="undefined"))
		{
			$.messager.alert('错误提示','类型不能为空!',"error");
			return;
		}
		 //知识库扩展属性配置项赋值
		var configstr=""
		if (($('#MKBTBEPType').combobox('getValue')=="S")||($('#MKBTBEPType').combobox('getValue')=="SD")){
			configstr=$('#ExtendProConfig').combobox('getValue');
		}
		if (($('#MKBTBEPType').combobox('getValue')=="R")||($('#MKBTBEPType').combobox('getValue')=="CB")||($('#MKBTBEPType').combobox('getValue')=="C")){
			var dataExtendConfig = $('#mygridExtendProConfig').datagrid('getRows');  
		    for(var i =0; i< dataExtendConfig.length;i++){  
		    	if ($.trim(dataExtendConfig[i].ConfigName)!=""){
			    	if (configstr==""){
						configstr=dataExtendConfig[i].ConfigName
					}else{
						configstr=configstr+"&%"+dataExtendConfig[i].ConfigName
					}
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
				param.MKBTBEPParRef = parref;
				param.MKBTBEPRowId = extendproid;
				param.MKBTBEPConfig = configstr;
			},
			success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
						$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
						$('#mygridExtendPro').datagrid('load',  { 
							ClassName:"web.DHCBL.MKB.MKBTermBaseExtendPro",         ///调用Query时
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
		$("#MKBTBEPType").combobox('setValue','TX');
	}*/
	//知识库扩展属性删除
	DelExtendPro=function(MKBTBEPRowId,id){ 
		if ((MKBTBEPRowId=="")||(MKBTBEPRowId==undefined)||(MKBTBEPRowId=="undefined")){ //前台删除
			$('#mygridExtendPro').datagrid('selectRecord',id);
			window.setTimeout(function(){
				var index=$('#mygridExtendPro').datagrid('getRowIndex',$('#mygridExtendPro').datagrid('getSelected'));
				$('#mygridExtendPro').datagrid('deleteRow',index);
				changeUpDownStatusEP();
			},50)
		}else{
			var parref=$("#mygridProperty").datagrid("getSelected").MKBTBPRowId
			$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
				if (r){	
					$.ajax({
						url:EXTENDPRO_DELETE_ACTION_URL,  
						data:{
							"id":MKBTBEPRowId     ///rowid
						},  
						type:"POST",   
						success: function(data){
								  var data=eval('('+data+')'); 
								  if (data.success == 'true') {
								  		$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
										$('#mygridExtendPro').datagrid('load',  { 
											ClassName:"web.DHCBL.MKB.MKBTermBaseExtendPro",         ///调用Query时
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
	
		SaveExtendPro=function(parref,operateType){
			var extendstr="";
			var rows = $("#mygridExtendPro").datagrid("getRows"); //获取当前页的所有行
			for(var i=0;i<rows.length;i++)
			{
				if ((rows[i].MKBTBEPRowId==undefined)||(rows[i].MKBTBEPRowId=="undefined")){rows[i].MKBTBEPRowId=""}
				if(extendstr!="") extendstr = extendstr+"*";
				extendstr=extendstr+rows[i].MKBTBEPName+"^"+rows[i].MKBTBEPType+"^"+rows[i].MKBTBEPConfig+"^"+rows[i].MKBTBEPRowId+"^"+rows[i].flag;
			}
			if (extendstr==""){ //属性保存时没有维护或不支持扩展属性时删除扩展属性
				$.ajax({
					url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermBaseExtendPro&pClassMethod=DeleteAll",  
					data:{
						"rowid":parref  
					},  
					type:"POST",
					success: function(data){
						  var data=eval('('+data+')'); 
						  if (data.success == 'true') {
							 		
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
					url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermBaseExtendPro&pClassMethod=SaveAll",  
					data:{
						"rowid":parref,    
						"extendstr":extendstr,
						"proOperateType":operateType
					},  
					type:"POST",
					success: function(data){
						  var data=eval('('+data+')'); 
						  if (data.success == 'true') {
							 		
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
	/******************************************知识库扩展属性维护结束*******************************************************/
	/******************************************知识库属性维护开始***********************************************************************************************/
	//格式
	$HUI.combobox("#MKBTBPType",{
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
			//{value:'M',text:'映射'},  //屏蔽映射格式 
			{value:'SS',text:'引用起始节点'},
			{value:'ETX',text:'文本编辑器'}
		]
	});
	//标识
	$HUI.combobox("#MKBTBPFlag",{
		valueField:'value',
		textField:'text',
		data:[
			{value:'S',text:'诊断展示名'},
			{value:'AL',text:'常用名/别名列表'}
		]
	});
	//医为百科展示方式 1.详情展示2.页头展示3.隐藏
	$HUI.combobox("#MKBTBPWikiShow",{
		valueField:'value',
		textField:'text',
		data:[
			{value:'details',text:'详情展示'},
			{value:'top',text:'页头展示'},
			{value:'hide',text:'隐藏'}
		]

	});
	/**********************知识库属性配置项开始*****************************************/
	//知识库属性配置项新增
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
	//知识库属性配置项删除
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
						var saveFlag =tkMakeServerCall("web.DHCBL.MKB.MKBTermBaseProperty","DeleteConfig",propertyid,index);
						if(saveFlag=="true")
						{
							$.messager.alert('提示','删除成功!',"info");
							$('#mygridPropertyConfig').datagrid('reload');
						}
						else
						{
							$.messager.alert('错误提示',saveFlag,"error");
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
			var configTool="<tr id='trconfig'><td align='right'><font color=red>*</font>配置项</td><td><input id='PropertyConfig' name='PropertyConfig' type='text' class='hisui-combobox'  style='width:208px' data-options='required:true'></td></tr>"
			var targetConfig = $(configTool).appendTo("#form-save-Property table");
			$.parser.parse(targetConfig);
			$("#PropertyConfig").combobox({
				url:$URL+"?ClassName=web.DHCBL.MKB.MKBTermBase&QueryName=GetDataForCmb1&ResultSetType=array",
				valueField:'MKBTBRowId',
				textField:'MKBTBDesc',
				mode:'remote',
				onSelect:function(record){
					//引用树形术语可以定义起始节点
					if ($("#trdefinednode").length>0){
						$("#trdefinednode").remove();
					}
					var type = tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetType",record.MKBTBRowId);
					if (type=="T"){
						var definednodeTool="<tr id='trdefinednode'><td align='right'>起始节点</td><td><input id='PropertyDefinedNode' name='PropertyDefinedNode' type='text' class='hisui-combotree'  style='width:208px' data-options=''></td></tr>"
						var targetDefinedNode = $(definednodeTool).appendTo("#form-save-Property table");
						$.parser.parse(targetDefinedNode);
						$HUI.combotree("#PropertyDefinedNode",{
							url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmb&base="+record.MKBTBRowId
						});
					}
				},
				onBeforeLoad:function(){
					//修改时加载起始节点
					var type = tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetType",config);
					if (type=="T"){
						var definednodeTool="<tr id='trdefinednode'><td align='right'>起始节点</td><td><input id='PropertyDefinedNode' name='PropertyDefinedNode' type='text' class='hisui-combotree'  style='width:208px' data-options=''></td></tr>"
						var targetDefinedNode = $(definednodeTool).appendTo("#form-save-Property table");
						$.parser.parse(targetDefinedNode);
						$HUI.combotree("#PropertyDefinedNode",{
							url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmb&base="+config
						});
					}
				}
			});
		}
		//知识表达式配置项
		else if((type=="SD")||(type=="SS")){
			var configTool="<tr id='trconfig'><td align='right'><font color=red>*</font>配置项</td><td><input id='PropertyConfig' name='PropertyConfig' type='text' class='hisui-combobox'  style='width:208px' data-options='required:true'></td></tr>"
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
			var configTool="<tr id='trconfig'><td align='right'><font color=red>*</font>配置项</td><td><input id='PropertyConfig' name='PropertyConfig' type='text' class='hisui-combobox'  style='width:208px' data-options='required:true'></td></tr>"
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
			//var trtool="<tr><td align='right'><font color=red>*</font>格式</td><input id='MKBTBPType' name='MKBTBPType' type='text' class='hisui-combobox'  style='width:300px' data-options=''></td></tr>"
			var targetConfigGrid=$("<tr id='trconfiggrid'><td colspan='2'><div style='width:290px;height:208px'><div id='mygridPropertyConfig' data-options='fit:true'></div></div></td></tr>").appendTo("#form-save-Property table");
			$.parser.parse(targetConfigGrid);
			//知识库属性可编辑配置项列表
			$("#mygridPropertyConfig").datagrid({
				url:$URL,
				queryParams:{
					ClassName:"web.DHCBL.MKB.MKBTermBaseProperty",         ///调用Query时
					QueryName:"GetConfigList",
					'rowid': propertyid
				},
				columns: [[  
				  {field:'ConfigNum',title:'ConfigNum',width:150,sortable:true,hidden:true},
				  {field:'ConfigName',title:'配置项名称',width:150,sortable:true,editor:{type:'validatebox'}}
				  ]],  //列信息
				pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
				pageSize:PageSizePop,
				pageList:[5,10,12,15,20,25,30,50,75,100,200,300,500,1000], 
				singleSelect:true,
				//idField:'ConfigNum', 
				rownumbers:true,    //设置为 true，则显示带有行号的列。
				fixRowNumber:true,
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
			$('#MKBTBEPName').attr("disabled",false);  
			$("#MKBTBEPName").validatebox({required:true})
			$('#MKBTBEPType').combobox('enable'); 
		}else{
			//禁用扩展属性
			$('#refresh_btn_ExtendPro').linkbutton('disable');
			$('#add_btn_ExtendPro').linkbutton('disable');
			$('#update_btn_ExtendPro').linkbutton('disable');
			$('#MKBTBEPName').attr("disabled",true);  
			$("#MKBTBEPName").validatebox({required:false})
			$('#MKBTBEPType').combobox('disable');  
		}
	}
	/**********************知识库属性配置项结束*****************************************/
	 //是否显示图片
	 IsShowImg=function(rowData){
	 	if (rowData=="")
	 	{
		 	ClearProperty();
			//清空中间属性列表，变为图片，改变标题
			if (document.getElementById('mygridProperty').style.display=="")   //如果是mygrid加载的状态
			{	
				$('#mygridProperty').datagrid('loadData', { total: 0, rows: [] }); 
				$('#mygridProperty').datagrid('unselectAll');
				document.getElementById('mygridProperty').style.display='none';  //隐藏mygrid
				$("#div-img").show();  //展示初始图片			
			}
	 	}
	 	else
	 	{
	 		document.getElementById('mygridProperty').style.display='';  //显示mygridProperty
			$("#div-img").hide();
			basedr=rowData.MKBTBRowId;
			$('#mygridProperty').datagrid('load',  { 
				ClassName:"web.DHCBL.MKB.MKBTermBaseProperty",
				QueryName:"GetList",
				'basedr':basedr
			});
			//$("#btnSearchProperty").searchbox('setValue', '');
			$("#TextSearchProperty").combobox('setValue', '');
			$('#mygridProperty').datagrid('unselectAll');
			
			$('#TextSearchProperty').searchcombobox({ 
			url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+"User.MKBTermBaseProperty"+basedr,
			onSelect:function () 
			{	
				$(this).combobox('textbox').focus();
				SearchProperty()
		        
	        }
		});
		 }
	 
	 }
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
	//知识库维护查询框
	 $('#TextSearchProperty').searchcombobox({ 
		url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+"User.MKBTermBaseProperty"+basedr,
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

    

	 
	//知识库属性重置按钮
	$("#btnRefreshProperty").click(function (e) { 
			ClearProperty();
	 }) 
	 //知识库属性新增按钮
	$("#btnAddProperty").click(function (e) { 
			AddProperty();
	 }) 
	 
	 //知识库属性修改按钮
	$("#btnUpdateProperty").click(function (e) { 
			UpdateProperty();
	 }) 
	 
	 //知识库属性删除按钮
	$("#btnDelProperty").click(function (e) { 
			DelProperty();
	 }) 
	 
	 //知识库属性保存按钮
	$("#save_btn_Property").click(function (e) { 
		if ($("#myWinProperty").dialog("options").title == "新增"){
			//顺序自动生成
			var LastSequence=parseInt(tkMakeServerCall("web.DHCBL.MKB.MKBTermBaseProperty","GetLastSequence",$("#mygrid").datagrid("getSelected").MKBTBRowId));
			$("#MKBTBPSequence").val(LastSequence+1)
			SaveProperty("","A");
		}else{
			SaveProperty($("#mygridProperty").datagrid("getSelected").MKBTBPRowId,"U");
		}
	 }) 
	 //知识库属性继续新增按钮
	$("#tadd_btn_Property").click(function (e) { 
		if ($("#myWinProperty").dialog("options").title == "新增"){
			//顺序自动生成
			var LastSequence=parseInt(tkMakeServerCall("web.DHCBL.MKB.MKBTermBaseProperty","GetLastSequence",$("#mygrid").datagrid("getSelected").MKBTBRowId));
			$("#MKBTBPSequence").val(LastSequence+1)
			TAddProperty("","A");
		}else{
			TAddProperty($("#mygridProperty").datagrid("getSelected").MKBTBPRowId,"U");
		}
	 }) 
	 //知识库属性关闭按钮
	 $("#close_btn_Property").click(function (e) { 
	 	$('#myWinProperty').dialog('close'); 
	 })
 
	//知识库属性查询方法
	SearchProperty=function (){
		//var desc=$.trim($("#btnSearchProperty").searchbox('getValue'));
		var desc=$("#TextSearchProperty").combobox('getText')
		$('#mygridProperty').datagrid('load',  { 
			ClassName:"web.DHCBL.MKB.MKBTermBaseProperty",
			QueryName:"GetList",
			'basedr': basedr,
			'desc':desc
		});
		//知识库属性上移下移移到首行按钮enable
		$('#btnUpProperty').linkbutton('enable');
		$('#btnDownProperty').linkbutton('enable');
		$('#btnFirstProperty').linkbutton('enable');
		$('#mygridProperty').datagrid('unselectAll');
	}
	
	//知识库属性重置方法
	ClearProperty=function ()
	{
		//$("#btnSearchProperty").searchbox('setValue', '');
		$("#TextSearchProperty").combobox('setValue', '');
		$('#mygridProperty').datagrid('load',  { 
			ClassName:"web.DHCBL.MKB.MKBTermBaseProperty",
			QueryName:"GetList",
			'basedr': basedr,
			'desc':""
		});
		//知识库属性上移下移移到首行按钮enable
		$('#btnUpProperty').linkbutton('enable');
		$('#btnDownProperty').linkbutton('enable');
		$('#btnFirstProperty').linkbutton('enable');
		$('#mygridProperty').datagrid('unselectAll');
	}
	//知识库属性点击新增按钮
	AddProperty=function () {
		var myWinProperty = $HUI.dialog("#myWinProperty",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			onOpen:function(){
				document.getElementById("tadd_btn_Property").style.display = ""; //隐藏继续新增按钮
			}
		});	
		$("#myWinProperty").show();
		propertyid="";
		RefreshProperty("");
	}
	//知识库属性点击修改按钮
	UpdateProperty=function () {
		var record = $("#mygridProperty").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		$("#myWinProperty").show(); 
		var myWinProperty = $HUI.dialog("#myWinProperty",{
			iconCls:'icon-w-edit',
			resizable:true,
			title:'修改',
			modal:true,
			onOpen:function(){
				document.getElementById("tadd_btn_Property").style.display = "none"; //隐藏继续新增按钮
			}
		});
		var id=record.MKBTBPRowId
		$.cm({
			ClassName:"web.DHCBL.MKB.MKBTermBaseProperty",
			MethodName:"OpenData",
			id:id
		},function(jsonData){
			var parref=jsonData.MKBTBPRowId
			RefreshProperty(id);
			if (jsonData.MKBTBPIsShowInLeft=="Y"){
				$HUI.checkbox("#MKBTBPIsShowInLeftF").setValue(true);	
			}else{
				$HUI.checkbox("#MKBTBPIsShowInLeftF").setValue(false);
			}
			$('#form-save-Property').form("load",jsonData);	
			AppendConfigTool(jsonData.MKBTBPType,id,jsonData.MKBTBPConfig)
			
			var contentflag=parseInt(tkMakeServerCall("web.DHCBL.MKB.MKBTermBaseProperty","FormValidateProDetail",id))
			if (contentflag==1)
			{
				if(jsonData.MKBTBPType=="TA")
				{
					$("#MKBTBPType").combobox('enable')	
				}
				else
				{
					$("#MKBTBPType").combobox('disable')
				}
				$('#MKBTBPCodeRules').attr('disabled','disabled')
			}
			else
			{
				$("#MKBTBPType").combobox('enable')
				$('#MKBTBPCodeRules').removeAttr('disabled')
			}
			$("#MKBTBPType").combobox('setValue',jsonData.MKBTBPType)	
			
			if ((jsonData.MKBTBPType=="L")||(jsonData.MKBTBPType=="P")||(jsonData.MKBTBPType=="T")){
				$HUI.combobox("#MKBTBPFlag",{
					valueField:'value',
					textField:'text',
					data:[
						{value:'S',text:'诊断展示名'},
						{value:'AL',text:'常用名/别名列表'},
						{value:'DT',text:'知识应用模板'},
						{value:'OD',text:'其他描述'}	
					],
					onSelect:function(record){
						ChangeMKBTBPFlag(record)
					}
				})
				$('#MKBTBPFlag').combobox('enable');
				$("#MKBTBPFlag").combobox('setValue',jsonData.MKBTBPFlag)
			}
			if ((jsonData.MKBTBPType=="S")||(jsonData.MKBTBPType=="SD")||(jsonData.MKBTBPType=="SS")){
				$("#PropertyConfig").combobox('setValue',jsonData.MKBTBPConfig)
				$("#PropertyDefinedNode").combotree('setValue',jsonData.MKBTBPDefinedNode)
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
			if (jsonData.MKBTBPType=="M"){
				$("#PropertyConfig").combobox('setValue',jsonData.MKBTBPConfig)
			}
			//文本，多行文本，单选，复选，下拉，引用术语，知识表达式，映射，引用起始节点,文本编辑器
			if ((jsonData.MKBTBPType=="TX")||(jsonData.MKBTBPType=="TA")||(jsonData.MKBTBPType=="R")||(jsonData.MKBTBPType=="CB")||(jsonData.MKBTBPType=="C")||(jsonData.MKBTBPType=="S")||(jsonData.MKBTBPType=="SD")||(jsonData.MKBTBPType=="M")||(jsonData.MKBTBPType=="SS")||(jsonData.MKBTBPType=="ETX")){
				//禁用扩展属性
				ableExtendPro(false);
			}else{
				//启用扩展属性
				ableExtendPro(true);
			}
			
		});
		
	}
	//知识库属性弹窗重置表单及列表
	RefreshProperty=function(parref){
		
		RemoveConfigTool();
		$('#form-save-Property').form("clear");
		$('#MKBTBPFlag').combobox('disable');
		$('#MKBTBPCodeRules').removeAttr('disabled');
		if (parref=="")
		{
			$HUI.checkbox("#MKBTBPIsShowInLeftF").setValue(false)
			//如勾选框默认不选择，需要去掉checked样式 ，如果默认勾选则不用加。2018-06-12
			$('#MKBTBPIsShowInLeftF').parent().removeClass("checked");
		}
		//扩展属性重置
	 	RemoveExtendConfigTool();
	 	$('#form-save-ExtendPro').form("clear");
		$("#MKBTBEPType").combobox('setValue','TX');
		$("#MKBTBPWikiShow").combobox('setValue','details');
		ableExtendPro(false);
        //知识库扩展属性列
		var columnsExtendPro =[[  
			  {field:'MKBTBEPRowId',title:'RowId',width:80,sortable:true,hidden:true},
			  {field:'Id',title:'Id',width:80,sortable:true,hidden:true},
			  {field:'flag',title:'标识',width:80,sortable:true,hidden:true},
			  {field:'operation',title:'操作',width:50,  
				formatter:function(value,rec,index){  
                   	//var delbtn = '<a href="#" id="btnDelExtendPro'+rec.MKBTBEPRowId+'" class="delcls" onclick="DelExtendPro(\''+rec.MKBTBEPRowId+'\',\''+index+'\')">删除</a>';  
					/*if ((rec.MKBTBEPRowId=="")||(rec.MKBTBEPRowId=="undefined")||(rec.MKBTBEPRowId==undefined)){
						var btnDelExtendProId=rec.MKBTBEPRowId
					}else{
						var btnDelExtendProId=rec.MKBTBEPRowId.replace("||","")
					}*/
					var delbtn = '<a href="#" id="btnDelExtendPro'+rec.MKBTBEPName+'" onclick="DelExtendPro(\''+rec.MKBTBEPRowId+'\',\''+rec.Id+'\')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" style="border:0px;"></a>';  
                  	return delbtn;    
			  }}  ,
			  {field:'MKBTBEPName',title:'扩展属性名称',width:130,sortable:true},
			  {field:'MKBTBEPType',title:'类型',width:60,sortable:true, 
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
			  {field:'MKBTBEPConfig',title:'配置项',width:100,sortable:true,
			  	formatter:function(value,rec){ 
			  		var columnConfig=rec.MKBTBEPConfig
			  		if ((rec.MKBTBEPType=="S")||(rec.MKBTBEPType=="SD")){
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
					var sortbtn = '<a href="#" id="btnUpExtendPro'+rec.MKBTBEPName+'" onclick="OrderFunLibExtendPro(\'up\')"><img src="../scripts/bdp/Framework/icons/mkb/shiftup.png" style="border:0px;"/></a>'
						+'<span>&nbsp;</span><a href="#" id="btnDownExtendPro'+rec.MKBTBEPName+'" onclick="OrderFunLibExtendPro(\'down\')"><img src="../scripts/bdp/Framework/icons/mkb/shiftdown.png" style="border:0px;"/></a>';  
					return sortbtn;    
			  }},
			  {field:'MKBTBEPSequence',title:'顺序',width:40,sortable:true,hidden:true},
			  {field:'configJson',title:'configJson',width:60,sortable:true,hidden:true}
			  ]];
		//知识库扩展属性列表
		var mygridExtendPro = $HUI.datagrid("#mygridExtendPro",{
			url:$URL,
			queryParams:{
				ClassName:"web.DHCBL.MKB.MKBTermBaseExtendPro",         ///调用Query时
				QueryName:"GetList",
				'parref':parref
			},
			columns: columnsExtendPro,  //列信息
			pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
			pageSize:PageSizePop,
			pageList:[5,10,12,15,20,25,30,50,75,100,200,300,500,1000], 
			singleSelect:true,
			idField:'MKBTBEPRowId', 
			rownumbers:false,    //设置为 true，则显示带有行号的列。
			fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
			remoteSort:false,  //定义是否从服务器排序数据。true
			onClickRow:function(rowIndex,rowData){
				extendproid=rowData.MKBTBEPRowId;
				var MKBTBPType=$("#MKBTBPType").combobox('getValue')
				//列表，树形，表单，知识应用模板
				if ((MKBTBPType=="L")||(MKBTBPType=="T")||(MKBTBPType=="F")||(MKBTBPType=="P")){
					RemoveExtendConfigTool();
					AppendExtendConfigTool(rowData.MKBTBEPType,rowData.MKBTBEPRowId,rowData.configJson)
					$("#MKBTBEPName").val(rowData.MKBTBEPName)
					$("#MKBTBEPType").combobox('setValue',rowData.MKBTBEPType)
					if ((rowData.MKBTBEPType=="S")||(rowData.MKBTBEPType=="SD")){
						$("#ExtendProConfig").combobox('setValue',rowData.MKBTBEPConfig)
					}
				}
				if ((MKBTBPType=="L")||(MKBTBPType=="T")){
					//扩展属性列表中的备注、检索码、上级分类不允许修改、不允许删除；
					if ((rowData.MKBTBEPName=="备注")||(rowData.MKBTBEPName=="检索码")||(rowData.MKBTBEPName=="上级分类")){
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
					if ((record.MKBTBPType=="TX")||(record.MKBTBPType=="TA")||(record.MKBTBPType=="R")||(record.MKBTBPType=="CB")||(record.MKBTBPType=="C")||(record.MKBTBPType=="S")||(record.MKBTBPType=="SD")||(record.MKBTBPType=="M")||(record.MKBTBPType=="SS")){
						//禁用扩展属性列删除按钮
						var rows = $("#mygridExtendPro").datagrid("getRows"); //获取当前页的所有行
						if (rows.length>0){
							for(var i=0;i<rows.length;i++)
							{
								//$('#btnDelExtendPro'+rows[i].MKBTBEPRowId.replace("||","")).addClass("disabled");
								$('#btnDelExtendPro'+rows[i].MKBTBEPName).addClass("disabled");
							}
						}
					}else{
						//启用扩展属性列删除按钮
						var rows = $("#mygridExtendPro").datagrid("getRows"); //获取当前页的所有行
						if (rows.length>0){
							for(var i=0;i<rows.length;i++)
							{
								//$('#btnDelExtendPro'+rows[i].MKBTBEPRowId.replace("||","")).removeClass("disabled");
								$('#btnDelExtendPro'+rows[i].MKBTBEPName).removeClass("disabled");
								$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","");
								$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","");
								if ((record.MKBTBPType=="L")||(record.MKBTBPType=="T")){ //列表型、树形
									if ((rows[i].flag=="main")||(rows[i].MKBTBEPName=="备注")||(rows[i].MKBTBEPName=="检索码")||(rows[i].MKBTBEPName=="上级分类")){
										$('#btnDelExtendPro'+rows[i].MKBTBEPName).addClass("disabled");
										$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","none");
										$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
									}
									if(record.MKBTBPType=="L"){
										if(i==3){ //列表型可排序的第一条扩展属性设置上移按钮不显示
											$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","none");
											if (rows.length==4){ //可排序数据仅有一条，上移下移按钮都不显示
												$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
											}
										}
									}
									if(record.MKBTBPType=="T"){
										if(i==4){ //树形可排序的第一条扩展属性设置上移按钮不显示
											$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","none");
											if (rows.length==5){ //可排序数据仅有一条，上移下移按钮都不显示
												$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
											}
										}
									}
								}else{ //其他类型
									if(i==0){ //可排序的第一条扩展属性设置上移按钮不显示
										$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","none");
										if (rows.length==1){ //可排序数据仅有一条，上移下移按钮都不显示
											$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
										}
									}
								}
								if (i+1==rows.length){ //最后一条扩展属性设置下移按钮不显示
									$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
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
				$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","");
				$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","");
				if (($("#MKBTBPType").combobox("getValue")=="L")||($("#MKBTBPType").combobox("getValue")=="T")){
					if ((rows[i].flag=="main")||(rows[i].MKBTBEPName=="备注")||(rows[i].MKBTBEPName=="检索码")||(rows[i].MKBTBEPName=="上级分类")){
						$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","none");
						$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
					}
					if($("#MKBTBPType").combobox("getValue")=="L"){
						if(i==3){ //列表型可排序的第一条扩展属性设置上移按钮不显示
							$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","none");
							if (rows.length==4){ //可排序数据仅有一条，上移下移按钮都不显示
								$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
							}
						}
					}
					if($("#MKBTBPType").combobox("getValue")=="T"){
						if(i==4){ //树形可排序的第一条扩展属性设置上移按钮不显示
							$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","none");
							if (rows.length==5){ //可排序数据仅有一条，上移下移按钮都不显示
								$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
							}
						}
					}
					
				}else{ //其他类型
					if(i==0){ //可排序的第一条扩展属性设置上移按钮不显示
						$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","none");
						if (rows.length==1){ //可排序数据仅有一条，上移下移按钮都不显示
							$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
						}
					}
				}
				if (i+1==rows.length){ //最后一条扩展属性设置下移按钮不显示
					$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
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
		$('#MKBTBPDesc').bind('blur',function(){
				/*var items = $("#mygridExtendPro").datagrid("getRows"); 
				if (items.length>0){
					 for (var i = items.length - 1; i >= 0; i--) {    
		                 var index = $('#mygridExtendPro').datagrid('getRowIndex', items[i]);    
		                 $('#mygridExtendPro').datagrid('deleteRow', index);    
		             }    
				}
				if ($("#myWinProperty").dialog("options").title == "修改"){
					var recordSelect = $("#mygridProperty").datagrid("getSelected");
					if (recordSelect.MKBTBPType==$("#MKBTBPType").combobox("getValue")){
						$('#mygridExtendPro').datagrid('load',  { 
								ClassName:"web.DHCBL.MKB.MKBTermBaseExtendPro",       
								QueryName:"GetList",
								'parref':recordSelect.MKBTBPRowId
							});
						
					}
				}*/
			//根据属性名称自动生成编码规则
			if($("#MKBTBPCodeRules").is(':disabled'))
			{
			}
			else
			{
				$("#MKBTBPCodeRules").val(Pinyin.GetJPU($('#MKBTBPDesc').val()))
		    }
		   
			//根据属性名称更新树型、列表型属性的扩展属性
			if (($("#MKBTBPType").combobox("getValue")=="L")||($("#MKBTBPType").combobox("getValue")=="T"))
			{			
				if (($('#MKBTBFlag').combobox('getValue'))=="AL")
				{
					/*var mainindex=0
					var items = $("#mygridExtendPro").datagrid("getRows"); 
					if (items.length>0){
						 for (var i = items.length - 1; i >= 0; i--) { 
						 	if (((items[i].MKBTBEPName=="展示名")||(items[i].MKBTBEPName=="别名"))&& (items[i].flag!=="main"))
						 	{
			                 	var index = $('#mygridExtendPro').datagrid('getRowIndex', items[i]);    
			                	 $('#mygridExtendPro').datagrid('deleteRow', index); 
						 	}
						 	else if(items[i].flag=="main")
						 	{
						 		var mainindex=$('#mygridExtendPro').datagrid('getRowIndex', items[i])
						 	}
			             }    
					}*/
					$('#mygridExtendPro').datagrid('updateRow',{
							index: 0,
							row: {
								MKBTBEPName: '别名'
							}
					})
				}
				else
				{
					var MKBTBPDesc1=$("#MKBTBPDesc").val()
					if((MKBTBPDesc1=="")||(MKBTBPDesc1=="展示名")||(MKBTBPDesc1=="别名"))
					{
						MKBTBPDesc1="中心词"
					}
					$('#mygridExtendPro').datagrid('updateRow',{
							index: 0,
							row: {
								MKBTBEPName: MKBTBPDesc1
							}
					})
					/*var items = $("#mygridExtendPro").datagrid("getRows"); 
					var shownameflag=0,othernameflag=0
					if (items.length>0){
						 for (var i = items.length - 1; i >= 0; i--) { 
						 	if (items[i].MKBTBEPName=="展示名")
						 	{
			                 	shownameflag=1 
						 	}
						 	if (items[i].MKBTBEPName=="别名")
						 	{
			                 	othernameflag=1 
						 	}
			             }    
					}
					if (shownameflag!==1 )
					{
						$('#mygridExtendPro').datagrid('appendRow',{  
								     MKBTBEPName : "展示名" ,
								     MKBTBEPType : "TX",
								     MKBTBEPConfig: "",
								     flag:'',
								     Id:'4',
								     MKBTBEPSequence:''
								}) 
					}
					if (othernameflag!==1 )
					{
						$('#mygridExtendPro').datagrid('appendRow',{  
								     MKBTBEPName : "别名" ,
								     MKBTBEPType : "TX",
								     MKBTBEPConfig: "",
								     flag:'',
								     Id:'5',
								     MKBTBEPSequence:''
								}) 
					}
				}*/
			}
			var rows = $("#mygridExtendPro").datagrid("getRows"); 
			if (rows.length>0){
					for(var i=0;i<rows.length;i++)
					{
						$('#btnDelExtendPro'+rows[i].MKBTBEPName).removeClass("disabled");
						$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","");
						$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","");
						if (($("#MKBTBPType").combobox("getValue")=="L")||($("#MKBTBPType").combobox("getValue")=="T")){
								if ((rows[i].flag=="main")||(rows[i].MKBTBEPName=="备注")||(rows[i].MKBTBEPName=="检索码")||(rows[i].MKBTBEPName=="上级分类")){
									$('#btnDelExtendPro'+rows[i].MKBTBEPName).addClass("disabled");
									$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","none");
									$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
								}
								if($("#MKBTBPType").combobox("getValue")=="L"){
									if(i==3){ //列表型可排序的第一条扩展属性设置上移按钮不显示
										$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","none");
										if (rows.length==4){ //可排序数据仅有一条，上移下移按钮都不显示
											$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
										}
									}
								}
								if($("#MKBTBPType").combobox("getValue")=="T"){
									if(i==4){ //树形可排序的第一条扩展属性设置上移按钮不显示
										$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","none");
										if (rows.length==5){ //可排序数据仅有一条，上移下移按钮都不显示
											$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
										}
									}
								}
								
							}
							else{ //其他类型
								if(i==0){ //可排序的第一条扩展属性设置上移按钮不显示
									$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","none");
									if (rows.length==1){ //可排序数据仅有一条，上移下移按钮都不显示
										$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
									}
								}
							}
							if (i+1==rows.length){ //最后一条扩展属性设置下移按钮不显示
								$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
							}
						}
					}				
			}
		  }); 
		  //标识切换事件
		ChangeMKBTBPFlag=function(record){
				if(record.value=="AL")
				{
					var mainindex=0
					var items = $("#mygridExtendPro").datagrid("getRows"); 
					if (items.length>0){
						 for (var i = items.length - 1; i >= 0; i--) { 
						 	if (((items[i].MKBTBEPName=="展示名")||(items[i].MKBTBEPName=="别名"))&& (items[i].flag!=="main"))
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
								MKBTBEPName: '别名'
							}
					})
				}
				else if((record.value=="S")||(record.value==""))
				{
					var MKBTBPDesc1=$("#MKBTBPDesc").val()
					if((MKBTBPDesc1=="")||(MKBTBPDesc1=="展示名")||(MKBTBPDesc1=="别名"))
					{
						MKBTBPDesc1="中心词"
					}
					$('#mygridExtendPro').datagrid('updateRow',{
							index: 0,
							row: {
								MKBTBEPName: MKBTBPDesc1
							}
					})
					var items = $("#mygridExtendPro").datagrid("getRows"); 
					var shownameflag=0,othernameflag=0
					if (items.length>0){
						 for (var i = items.length - 1; i >= 0; i--) { 
						 	if (items[i].MKBTBEPName=="展示名")
						 	{
			                 	shownameflag=1 
						 	}
						 	if (items[i].MKBTBEPName=="别名")
						 	{
			                 	othernameflag=1 
						 	}
			             }    
					}
					if (shownameflag!==1 )
					{
						$('#mygridExtendPro').datagrid('appendRow',{  
								     MKBTBEPName : "展示名" ,
								     MKBTBEPType : "TX",
								     MKBTBEPConfig: "",
								     flag:'',
								     Id:'4',
								     MKBTBEPSequence:''
								}) 
					}
					if (othernameflag!==1 )
					{
						$('#mygridExtendPro').datagrid('appendRow',{  
								     MKBTBEPName : "别名" ,
								     MKBTBEPType : "TX",
								     MKBTBEPConfig: "",
								     flag:'',
								     Id:'5',
								     MKBTBEPSequence:''
								}) 
					}
				}
			
				var rows = $("#mygridExtendPro").datagrid("getRows"); 
				if (rows.length>0)
				{
					for(var i=0;i<rows.length;i++)
					{
						$('#btnDelExtendPro'+rows[i].MKBTBEPName).removeClass("disabled");
						$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","");
						$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","");
						if (($("#MKBTBPType").combobox("getValue")=="L")||($("#MKBTBPType").combobox("getValue")=="T")){
								if ((rows[i].flag=="main")||(rows[i].MKBTBEPName=="备注")||(rows[i].MKBTBEPName=="检索码")||(rows[i].MKBTBEPName=="上级分类")){
									$('#btnDelExtendPro'+rows[i].MKBTBEPName).addClass("disabled");
									$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","none");
									$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
								}
								if($("#MKBTBPType").combobox("getValue")=="L"){
									if(i==3){ //列表型可排序的第一条扩展属性设置上移按钮不显示
										$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","none");
										if (rows.length==4){ //可排序数据仅有一条，上移下移按钮都不显示
											$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
										}
									}
								}
								if($("#MKBTBPType").combobox("getValue")=="T"){
									if(i==4){ //树形可排序的第一条扩展属性设置上移按钮不显示
										$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","none");
										if (rows.length==5){ //可排序数据仅有一条，上移下移按钮都不显示
											$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
										}
									}
								}
								
							}
							else{ //其他类型
								if(i==0){ //可排序的第一条扩展属性设置上移按钮不显示
									$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","none");
									if (rows.length==1){ //可排序数据仅有一条，上移下移按钮都不显示
										$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
									}
								}
							}
							if (i+1==rows.length){ //最后一条扩展属性设置下移按钮不显示
								$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
							}
						}
					}	
			}
			
		//格式切换事件：对扩展属性列表操作
		$("#MKBTBPType").combobox({  
			onSelect:function(record){
				RemoveConfigTool();
				//格式为列表型、知识应用模板时标识可用
				if ((record.value=="L")||(record.value=="P")||(record.value=="T"))
				{
					if (record.value=="L")
					{
						$HUI.combobox("#MKBTBPFlag",{
							valueField:'value',
							textField:'text',
							data:[
								{value:'S',text:'诊断展示名'},
								{value:'AL',text:'常用名/别名列表'}	  
							],
							onSelect:function(record){
								ChangeMKBTBPFlag(record)
							}
						});
					}
					else if(record.value=="T"){
						$HUI.combobox("#MKBTBPFlag",{
							valueField:'value',
							textField:'text',
							data:[
								{value:'OD',text:'其他描述'}		  
							]
						});
					}
					else
					{
						$HUI.combobox("#MKBTBPFlag",{
							valueField:'value',
							textField:'text',
							data:[
								{value:'DT',text:'知识应用模板'}		  
							]
						});
					}
					$('#MKBTBPFlag').combobox('enable');
				}
				else
				{
					$('#MKBTBPFlag').combobox('setValue','');
					$('#MKBTBPFlag').combobox('disable');
				}
				RemoveExtendConfigTool();
				$('#form-save-ExtendPro').form("clear");
				$("#MKBTBEPType").combobox('setValue','TX');
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
					if (recordSelect.MKBTBPType==record.value){
						$('#mygridExtendPro').datagrid('load',  { 
								ClassName:"web.DHCBL.MKB.MKBTermBaseExtendPro",       
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
							$('#btnDelExtendPro'+rows[i].MKBTBEPName).addClass("disabled");
						}
					}
				}else{
					ableExtendPro(true) 
					//启用扩展属性列删除按钮
					var rows = $("#mygridExtendPro").datagrid("getRows"); //获取当前页的所有行
					if (rows.length>0){
						for(var i=0;i<rows.length;i++)
						{
							$('#btnDelExtendPro'+rows[i].MKBTBEPName).removeClass("disabled");
						}
					}
					
					if ((record.value=="L")||(record.value=="T")){
							if (($('#MKBTBFlag').combobox('getValue'))=="AL")
							{
								//主列名称，初始内容为中心词,允许修改不允许删除,保存到属性表的主列名称字段
								$('#mygridExtendPro').datagrid('appendRow',{  
								     MKBTBEPName : "别名" , //"中心词",
								     MKBTBEPType : "TX",
								     MKBTBEPConfig: "",
								     flag:"main",
								     Id:'1',
								     MKBTBEPSequence:''
								     
								}) 
								//备注， 不能修改不能删除，要显示，不保存
								$('#mygridExtendPro').datagrid('appendRow',{  
								     MKBTBEPName : "备注" ,
								     MKBTBEPType : "TA",
								     MKBTBEPConfig: "",
								     flag:'',
								     Id:'2',
								     MKBTBEPSequence:''
								}) 
								//检索码， 不允许修改删除，要显示，不保存
								$('#mygridExtendPro').datagrid('appendRow',{  
								     MKBTBEPName : "检索码" ,
								     MKBTBEPType : "TX",
								     MKBTBEPConfig: "",
								     flag:'',
								     Id:'3',
								     MKBTBEPSequence:''
								}) 
								//树形格式属性需生成扩展属性上级分类， 不允许修改删除，要显示，不保存
								if (record.value=="T"){
									$('#mygridExtendPro').datagrid('appendRow',{  
									     MKBTBEPName : "上级分类" ,
									     MKBTBEPType : "TX",
									     MKBTBEPConfig: "",
									     flag:'',
									     Id:'6',
									     MKBTBEPSequence:''
									}) 
								}
							
							}
							else
							{
								//主列名称，初始内容为中心词,允许修改不允许删除,保存到属性表的主列名称字段
								var MKBTBPDesc1=$("#MKBTBPDesc").val()
								if((MKBTBPDesc1=="")||(MKBTBPDesc1=="展示名")||(MKBTBPDesc1=="别名"))
								{
									MKBTBPDesc1="中心词"
								}
								$('#mygridExtendPro').datagrid('appendRow',{  
								     MKBTBEPName : MKBTBPDesc1, //"中心词", ,
								     MKBTBEPType : "TX",
								     MKBTBEPConfig: "",
								     flag:"main",
								     Id:'1',
								     MKBTBEPSequence:''
								     
								}) 
								//备注， 不能修改不能删除，要显示，不保存
								$('#mygridExtendPro').datagrid('appendRow',{  
								     MKBTBEPName : "备注" ,
								     MKBTBEPType : "TA",
								     MKBTBEPConfig: "",
								     flag:'',
								     Id:'2',
								     MKBTBEPSequence:''
								}) 
								//检索码， 不允许修改删除，要显示，不保存
								$('#mygridExtendPro').datagrid('appendRow',{  
								     MKBTBEPName : "检索码" ,
								     MKBTBEPType : "TX",
								     MKBTBEPConfig: "",
								     flag:'',
								     Id:'3',
								     MKBTBEPSequence:''
								}) 
								//树形格式属性需生成扩展属性上级分类， 不允许修改删除，要显示，不保存
								if (record.value=="T"){
									$('#mygridExtendPro').datagrid('appendRow',{  
									     MKBTBEPName : "上级分类" ,
									     MKBTBEPType : "TX",
									     MKBTBEPConfig: "",
									     flag:'',
									     Id:'6',
									     MKBTBEPSequence:''
									}) 
								}
								$('#mygridExtendPro').datagrid('appendRow',{  
								     MKBTBEPName : "展示名" ,
								     MKBTBEPType : "TX",
								     MKBTBEPConfig: "",
								     flag:'',
								     Id:'4',
								     MKBTBEPSequence:''
								}) 
								$('#mygridExtendPro').datagrid('appendRow',{  
								     MKBTBEPName : "别名" ,
								     MKBTBEPType : "TX",
								     MKBTBEPConfig: "",
								     flag:'',
								     Id:'5',
								     MKBTBEPSequence:''
								}) 
							}
					}
					//知识应用模板
					if (record.value=="P"){
						$('#mygridExtendPro').datagrid('appendRow',{  
							     MKBTBEPName : "缺省展示效果" ,
							     MKBTBEPType : "TX",
							     MKBTBEPConfig: ""
							}) 
					}
					if (rows.length>0){
						for(var i=0;i<rows.length;i++)
						{
							$('#btnDelExtendPro'+rows[i].MKBTBEPName).removeClass("disabled");
							$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","");
							$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","");
							if ((record.value=="L")||(record.value=="T")){
									if ((rows[i].flag=="main")||(rows[i].MKBTBEPName=="备注")||(rows[i].MKBTBEPName=="检索码")||(rows[i].MKBTBEPName=="上级分类")){
										$('#btnDelExtendPro'+rows[i].MKBTBEPName).addClass("disabled");
										$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","none");
										$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
									}
									if(record.value=="L"){
										if(i==3){ //列表型可排序的第一条扩展属性设置上移按钮不显示
											$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","none");
											if (rows.length==4){ //可排序数据仅有一条，上移下移按钮都不显示
												$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
											}
										}
									}
									if(record.value=="T"){
										if(i==4){ //树形可排序的第一条扩展属性设置上移按钮不显示
											$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","none");
											if (rows.length==5){ //可排序数据仅有一条，上移下移按钮都不显示
												$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
											}
										}
									}
									
								}
								else{ //其他类型
									if(i==0){ //可排序的第一条扩展属性设置上移按钮不显示
										$('#btnUpExtendPro'+rows[i].MKBTBEPName).css("display","none");
										if (rows.length==1){ //可排序数据仅有一条，上移下移按钮都不显示
											$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
										}
									}
								}
								if (i+1==rows.length){ //最后一条扩展属性设置下移按钮不显示
									$('#btnDownExtendPro'+rows[i].MKBTBEPName).css("display","none");
								}
							}
						}
						
				}
			}
		
		});
	}
	///知识库属性新增、更新
	SaveProperty=function (id,operateType)
	{	
		 if(indexPropertyConfig!==""){
	           $("#mygridPropertyConfig").datagrid('endEdit', indexPropertyConfig);
	        }
		if ($.trim($("#MKBTBPDesc").val())=="")
		{
			$.messager.alert('错误提示','属性名称不能为空!',"error");
			return;
		}
		if (($('#MKBTBPType').combobox('getValue')=="")||($('#MKBTBPType').combobox('getValue')=="undefined"))
		{
			$.messager.alert('错误提示','格式不能为空!',"error");
			return;
		}
		
		if ($('#MKBTBPFlag').combobox('getValue')!=""){
			var flag = tkMakeServerCall("web.DHCBL.MKB.MKBTermBaseProperty","ValidateFlag",id,$('#MKBTBPFlag').combobox('getValue'),basedr);
			if (flag==1){
				$.messager.alert('错误提示','已经存在此标识的属性!',"error");
				return;
			}
		}
		if ($.trim($("#MKBTBPCodeRules").val())=="")
		{
			$.messager.alert('错误提示','编码规则不能为空!',"error");
			return;
		}
		
		//配置项赋值
		var configstr=""
		var definednode=""
		if (($('#MKBTBPType').combobox('getValue')=="S")||($('#MKBTBPType').combobox('getValue')=="SD")||($('#MKBTBPType').combobox('getValue')=="M")||($('#MKBTBPType').combobox('getValue')=="SS")){
			configstr=$('#PropertyConfig').combobox('getValue');
			if (configstr==""){
		    	$.messager.alert('错误提示','配置项不能为空!',"error");
  				return;
		    }
		    if ($('#MKBTBPType').combobox('getValue')=="S"){
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
		}
		if (($('#MKBTBPType').combobox('getValue')=="R")||($('#MKBTBPType').combobox('getValue')=="CB")||($('#MKBTBPType').combobox('getValue')=="C")){
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
		
		
		if(($('#MKBTBPType').combobox('getValue')=="L")||($('#MKBTBPType').combobox('getValue')=="T"))
		{
			var rows = $("#mygridExtendPro").datagrid("getRows"); //获取当前页的所有行
			var MKBTBPName=rows[0].MKBTBEPName
		}
		
		$('#form-save-Property').form('submit', { 
			url: PROPERTY_SAVE_ACTION_URL, 
			onSubmit: function(param){
				param.MKBTBPBaseDr = basedr;
				param.MKBTBPRowId = id;
				param.MKBTBPConfig = configstr;
				param.MKBTBPDefinedNode = definednode;
				param.MKBTBPCodeRules = $("#MKBTBPCodeRules").val();
				param.MKBTBPName = MKBTBPName;
			},
			success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
				  		propertyresid=data.id;
				  		var MKBTBPType=$("#MKBTBPType").combobox('getValue')
				  		SaveExtendPro(propertyresid,operateType);//保存扩展属性
				  		$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
						$('#mygridProperty').datagrid('reload');  // 重新载入当前页面数据 
						$('#myWinProperty').dialog('close'); // close a dialog
				  } else if(data.success == 'repeat'){
				  		propertyresid=data.id;
				  		var MKBTBPType=$("#MKBTBPType").combobox('getValue')
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
				}

			} 
		});
	}
	//知识库属性继续新增
	TAddProperty=function (id,operateType)
	{	
		if(indexPropertyConfig!==""){
	           $("#mygridPropertyConfig").datagrid('endEdit', indexPropertyConfig);
	        }
		if ($.trim($("#MKBTBPDesc").val())=="")
		{
			$.messager.alert('错误提示','属性名称不能为空!',"error");
			return;
		}
		if (($('#MKBTBPType').combobox('getValue')=="")||($('#MKBTBPType').combobox('getValue')=="undefined"))
		{
			$.messager.alert('错误提示','格式不能为空!',"error");
			return;
		}
		if ($('#MKBTBPFlag').combobox('getValue')!=""){
			var flag = tkMakeServerCall("web.DHCBL.MKB.MKBTermBaseProperty","ValidateFlag",id,$('#MKBTBPFlag').combobox('getValue'),basedr);
			if (flag==1){
				$.messager.alert('错误提示','已经存在此标识的属性!',"error");
				return;
			}
		}
		if ($.trim($("#MKBTBPCodeRules").val())=="")
		{
			$.messager.alert('错误提示','编码规则不能为空!',"error");
			return;
		}
		//配置项赋值
		var configstr=""
		var definednode=""
		if (($('#MKBTBPType').combobox('getValue')=="S")||($('#MKBTBPType').combobox('getValue')=="SD")||($('#MKBTBPType').combobox('getValue')=="M")||($('#MKBTBPType').combobox('getValue')=="SS")){
			configstr=$('#PropertyConfig').combobox('getValue');
			if (configstr==""){
		    	$.messager.alert('错误提示','配置项不能为空!',"error");
  				return;
		    }
		    if ($('#MKBTBPType').combobox('getValue')=="S"){
				var type = tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetType",configstr);
				if (type=="T"){
					//起始节点赋值
					definednode=$('#PropertyDefinedNode').combotree('getValue');	
				}
		    }
		}
		if (($('#MKBTBPType').combobox('getValue')=="R")||($('#MKBTBPType').combobox('getValue')=="CB")||($('#MKBTBPType').combobox('getValue')=="C")){
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
				param.MKBTBPBaseDr = basedr;
				param.MKBTBPRowId = id;
				param.MKBTBPConfig = configstr;
				param.MKBTBPDefinedNode = definednode;
			},
			success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
				  		propertyresid=data.id;
				  		var MKBTBPType=$("#MKBTBPType").combobox('getValue')
				  		SaveExtendPro(propertyresid,operateType);//保存扩展属性
				  		$('#myWinProperty').dialog({title: "新增"});
				  		propertyid="";
				  		RefreshProperty("");
				  		$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
						$('#mygridProperty').datagrid('reload');  // 重新载入当前页面数据 
				  } 
				  else if(data.success == 'repeat'){
				  		propertyresid=data.id;
				  		var MKBTBPType=$("#MKBTBPType").combobox('getValue')
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
	///知识库属性删除
	DelProperty=function ()
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
						"id":record.MKBTBPRowId      ///rowid
					},  
					type:"POST",   
					beforeSend: function () {
						loadMask();
					},
					complete: function () {
					    removeMask();
					},
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
							  		$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
									RefreshSearchData("User.MKBTermBaseProperty"+$("#mygrid").datagrid("getSelected").MKBTBRowId,record.MKBTBPRowId,"D","")
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
				})
			}
		});
	}
	/******************上移、下移、移到首行开始******************************************/
	//知识库属性上移按钮
	$("#btnUpProperty").click(function (e) { 
			OrderFunLib("up");
	 })
	 
	 //知识库属性下移按钮
	$("#btnDownProperty").click(function (e) { 
			OrderFunLib("down");
	 })
	 
	 //知识库属性移到首行按钮
	$("#btnFirstProperty").click(function (e) { 
			OrderFunLib("first");
	 })
	 //改变上移下移按钮状态
	changeUpDownStatus=function(rowIndex)
	{
			if(rowIndex==0){
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
	 
	//上移 下移 移到首行
	OrderFunLib=function(type)
	{
		var row = $("#mygridProperty").datagrid("getSelected"); 
		if (!(row))
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}	   
		var index = $("#mygridProperty").datagrid('getRowIndex', row);	
		mysort(index, type, "mygridProperty")
		
		//改变上移、下移按钮的状态
		var nowrow = $('#mygridProperty').datagrid('getSelected');  
		var rowIndex=$('#mygridProperty').datagrid('getRowIndex',nowrow);  
		changeUpDownStatus(rowIndex)
		
		//遍历列表
		var order=""
		var rows = $('#mygridProperty').datagrid('getRows');	
		var Sequence=parseInt(rows[0].MKBTBPSequence)
		for(var i=0; i<rows.length; i++){	
			var id =rows[i].MKBTBPRowId; //频率id
			var seq=rows[i].MKBTBPSequence;
			if (parseInt(seq)<Sequence){
				Sequence=parseInt(seq)
			}
			if (order!=""){
				order = order+"&%"+id
			}else{
				order = id
			}
		}
		//获取级别默认值
		$.m({
			ClassName:"web.DHCBL.MKB.MKBTermBaseProperty",
			MethodName:"SaveDragOrder",
			order:order,
			seq:Sequence
			},function(txtData){
			//alert(order+txtData)
		});
	}
		//上移、下移、移到首行方法
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

	/******************上移、下移、移到首行结束******************************************/
	//知识库属性列
	var columnsProperty =[[  
				  {field:'MKBTBPRowId',title:'RowId',width:80,sortable:true,hidden:true},
				  {field:'MKBTBPCode',title:'代码',width:150,sortable:true,hidden:true},
				  {field:'MKBTBPDesc',title:'属性名称',width:150,sortable:true},
				  {field:'MKBTBPType',title:'格式',width:150,sortable:true, 
				  formatter:function(v,row,index){  
						if(v=='TX'){return '文本';}
						if(v=='TA'){return '多行文本框';}
						if(v=='R'){return '单选框';}
						if(v=='CB'){return '复选框';}
						if(v=='C'){return '下拉框';}
						if(v=='L'){return '列表';}
						if(v=='T'){return '树形';}
						if(v=='F'){return '表单';}
						if(v=='S'){return '引用术语';}
						if(v=='P'){return '知识应用模板';}
						if(v=='SD'){return '知识表达式';}
						if(v=='M'){return '映射';}
						if(v=='SS'){return '引用起始节点';}
						if(v=='ETX'){return '文本编辑器';}
					}},
				  {field:'MKBTBPConfig',title:'配置项',width:150,sortable:true,
				  	formatter:function(value,rec){ 
				  		var columnConfig=rec.MKBTBPConfig
				  		if ((rec.MKBTBPType=="S")||(rec.MKBTBPType=="SD")||(rec.MKBTBPType=="SS")){
				  			columnConfig=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetDesc",value)
				  		}
				  		else if(rec.MKBTBPType=="M"){
				  			columnConfig=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingBase","GetDesc",value)
				  		}
				  		else{
				  			if (columnConfig.indexOf("&%")>0){
				  				columnConfig=columnConfig.replace(/\&%/g,",")
					  		}
				  		}
				  		return columnConfig;
				  	}
				  },
				  {field:'MKBTBPName',title:'主列名称',width:150,sortable:true},
				  {field:'MKBTBPFlag',title:'标识',width:150,sortable:true,
				  formatter:function(v,row,index){  
						if(v=='S'){return '诊断展示名';}
						if(v=='AL'){return '常用名/别名列表';}
						if(v=='DT'){return '知识应用模板';}
						if(v=='OD'){return '其他描述';}
					}},
				  {field:'MKBTBPCodeRules',title:'编码规则',width:150,sortable:true,hidden:true},
				  {field:'MKBTBPSequence',title:'顺序',width:80,sortable:true,hidden:true,
				  sorter:function (a,b){  
					    if(a.length > b.length) return 1;
					        else if(a.length < b.length) return -1;
					        else if(a > b) return 1;
					        else return -1;
					}
				  }
				  ]];
	//知识库属性列表
	var mygridProperty = $HUI.datagrid("#mygridProperty",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.MKB.MKBTermBaseProperty",         ///调用Query时
			QueryName:"GetList"
		},
		ClassTableName:'User.MKBTermBaseProperty'+basedr,
		SQLTableName:'MKB_TermBaseProperty',
		columns: columnsProperty,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		idField:'MKBTBPRowId', 
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		sortName:'MKBTBPSequence',
		sortOrder:'asc',
		toolbar:'#mytbarProperty',
		onClickRow:function(rowIndex,rowData){
			//改变上移下移按钮状态
			changeUpDownStatus(rowIndex);
			propertyid=rowData.MKBTBPRowId;
			RefreshSearchData("User.MKBTermBaseProperty"+$("#mygrid").datagrid("getSelected").MKBTBRowId,propertyid,"A",rowData.MKBTBPDesc)
		},
		onDblClickRow:function(rowIndex,rowData){
			//改变上移下移按钮状态
			changeUpDownStatus(rowIndex);
        	UpdateProperty();
        },
        onLoadSuccess:function(data){
        	//检索框自动选中第一条，如果可以展开就展开，不能展开就选中,或者属性id不为空
			 var searchprovalue=$('#TextSearchProperty').combobox('getText')
			 if (searchprovalue!="")
			 {
			 	if (data.total!=0)
			 	{
				 	$('#mygridProperty').datagrid('selectRow',0);
					var rowData=$('#mygridProperty').datagrid('getSelected')
				 }
			}
        	$(this).datagrid('columnMoving');
 		}
	});
	ShowUserHabit('mygridProperty');
	

	/**
	 * linkbutton方法扩展 disable和enable覆盖重写
	 * @param {Object} jq
	 */
/*	$.extend($.fn.linkbutton.methods, {
	    *//**
	     * 激活选项（覆盖重写）
	     * @param {Object} jq
	     *//*
	    enable: function(jq){
	        return jq.each(function(){
	            var state = $.data(this, 'linkbutton');
	            if ($(this).hasClass('l-btn-disabled')) {
	                var itemData = state._eventsStore;
	                //恢复超链接
	                if (itemData.href) {
	                    $(this).attr("href", itemData.href);
	                }
	                //回复点击事件
	                if (itemData.onclicks) {
	                    for (var j = 0; j < itemData.onclicks.length; j++) {
	                        $(this).bind('click', itemData.onclicks[j]);
	                    }
	                }
	                //设置target为null，清空存储的事件处理程序
	                itemData.target = null;
	                itemData.onclicks = [];
	                $(this).removeClass('l-btn-disabled');
	            }
	        });
	    },
	    *//**
	     * 禁用选项（覆盖重写）
	     * @param {Object} jq
	     *//*
	    disable: function(jq){
	        return jq.each(function(){
	            var state = $.data(this, 'linkbutton');
	            if (!state._eventsStore)
	                state._eventsStore = {};
	            if (!$(this).hasClass('l-btn-disabled')) {
	                var eventsStore = {};
	                eventsStore.target = this;
	                eventsStore.onclicks = [];
	                //处理超链接
	                var strHref = $(this).attr("href");
	                if (strHref) {
	                    eventsStore.href = strHref;
	                    $(this).attr("href", "javascript:void(0)");
	                }
	                //处理直接耦合绑定到onclick属性上的事件
	                var onclickStr = $(this).attr("onclick");
	                if (onclickStr && onclickStr != "") {
	                    eventsStore.onclicks[eventsStore.onclicks.length] = new Function(onclickStr);
	                    $(this).attr("onclick", "");
	                }
	                //处理使用jquery绑定的事件
	                var eventDatas = $(this).data("events") || $._data(this, 'events');
	                if (eventDatas["click"]) {
	                    var eventData = eventDatas["click"];
	                    for (var i = 0; i < eventData.length; i++) {
	                        if (eventData[i].namespace != "menu") {
	                            eventsStore.onclicks[eventsStore.onclicks.length] = eventData[i]["handler"];
	                            $(this).unbind('click', eventData[i]["handler"]);
	                            i--;
	                        }
	                    }
	                }
	                state._eventsStore = eventsStore;
	                $(this).addClass('l-btn-disabled');
	            }
	        });
	    }
	});*/
	/******************************************知识库属性维护结束***********************************************************************************************/
}
$(init);