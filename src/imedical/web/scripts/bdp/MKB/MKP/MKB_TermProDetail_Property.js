/// 名称: 医用知识库 -引用属性格式的属性内容维护
/// 描述: 包含增删改上移下移等功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2018-04-03

var init = function(){

	var HISUI_SQLTableName="MKB_TermProDetail"+property,HISUI_ClassTableName="User.MKBTermProDetail"+property;
	
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=DeleteData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=SaveData&pEntityName=web.Entity.MKB.MKBTermProDetail";
	var PRO_TREE_COMBO_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetJsonDataForCmb"
	var TERM_TREE_COMBO_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetJsonDataForTermCmb"
	//var property=1
	var activeIndex="";   //正在编辑行的行号
	var changeflag=""    //是否改动数据的标识
	//var activeId=""     //正在编辑行的id
	var deletePropertys=""  //删除诊断模版-引用起始节点类型的模版项时，要同步删除该属性
	
	var gridSingleSelect=true  //grid单选状态
	if (addTermId!="")   //要添加的术语id
	{
		gridSingleSelect=false
		var baseFlag=tkMakeServerCall('web.DHCBL.MKB.MKBTermProDetail','GetTermBaseFlag',addTermId);
		if (baseFlag=="Part")
		{
			$("#btnAddPart").css('display',''); 
		}
		if (baseFlag=="Pathogeny")
		{
			$("#btnAddPath").css('display',''); 
		}
	}
	
	//定义弹窗的高度和宽度
	var winwidth=1200,winheight=520
	if (parent.TermID!="")
	{
		winwidth=window.screen.width-400 //定义展开属性内容的宽带
		winheight=window.screen.height-300 //定义展开属性内容的高度
		
	}
	else
	{
		winwidth=parent.parent.$("#myTabContent").width()-60 //定义展开属性内容的宽度
		winheight=parent.parent.$("#myTabContent").height()-40 //定义展开属性内容的高度
	}
		
	//获取扩展属性信息	
	var extendInfo=tkMakeServerCall('web.DHCBL.MKB.MKBTermProDetail','getExtendInfo',property);
	var extend=extendInfo.split("[A]")
	var propertyName = extend[0];  //主列名
	var extendChild =extend[1];  //扩展属性child串
	var extendTitle =extend[2];  //扩展属性名串
	var extendType =extend[3];    //扩展属性格式串
	var extendConfig =extend[4];    //扩展属性配置项串
	var termBase =extend[5];    //术语所属术语库id
	var termRowId =extend[6];    //术语id
	
	if (termRowId!="")
	{
		var DTProperty=tkMakeServerCall('web.DHCBL.MKB.MKBTermProperty','GetPropertyIdByFlag',termRowId,"DT"); //知识应用模板的属性id
		if (DTProperty==property)  //如果这个属性就是知识应用模板 ，则预览按钮显示，否则不显示
		{
			$("#btnPreview").css('display',''); 
		}
		else
		{
			$("#btnPreview").css('display','none'); 
		}
	}
	else
	{
		$("#btnPreview").css('display','none'); 
	}
	
	
	var urlArr=[]   //引用列表型控件的url信息

	//缺省展示效果的id,用于缺省展示效果文本框内容的自动生成
	var emptycomid=""

	if (extendChild!="")   //如果有扩展属性，则自动生成列
	{
		var colsField = extendChild.split("[N]"); 
		var colsHead = extendTitle.split("[N]"); 
		var typeStr = extendType.split("[N]"); 
		var configStr = extendConfig.split("[N]"); 
		//alert(configStr)
		for (var i = 0; i <colsField.length; i++) 
		{
			var fieldid=colsField[i];
			var labelName=colsHead[i];  //标题
			var comId='Extend'+colsField[i];   //控件id			
			var type=typeStr[i]   //类型
			var configInfos=configStr[i]  //配置项
			if (labelName=="缺省展示效果")
			{
				emptycomid=comId
			}
			if (type=="TX")  //文本框
			{
				var newRow='<tr>'+
				   '<td class="tdlabel">'+labelName+'</td>'+
				   '<td><input id="'+comId+'" name="'+comId+'" type="text" style="width:480px;"></td>'+
				'</tr>'
				$('#form-save table').append(newRow);
				$('#'+comId).validatebox()
			}
			else if(type=="TA")  //多行文本框
			{
				var newRow='<tr>'+
				   '<td class="tdlabel">'+labelName+'</td>'+
				   '<td><textarea id="'+comId+'" name="'+comId+'" type="text" style="height:60px;width:928px;"></textarea></td>'+
				'</tr>'
				$('#form-save table').append(newRow);
				$('#'+comId).validatebox()		
			}
			else if(type=="S")  //引用  注意：要换成MKBTerm，同时还要判断是列表下拉框还是树形下拉框
			{			
				if (configInfos=="") return 
				var newRow='<tr>'+
				   '<td class="tdlabel">'+labelName+'</td>'+
				   '<td><input id="'+comId+'" name="'+comId+'" type="text" style="width:480px;"></td>'
				'</tr>'
				$('#form-save table').append(newRow);
				var baseInfo = configInfos.split("&%"); 
				var baseid=baseInfo[0]   //术语库注册id
				var baseType=baseInfo[1]   //术语库类型
				if (baseType=="T")  //下拉树			
				{
					$('#'+comId).combotree({ 
						url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmb&base="+baseid,
						onBeforeExpand:function(node){
							$(this).tree('expandFirstChildNodes',node)
					    },
						onHidePanel:function(){
							if($(this).combo('getText')==""){
								$(this).combo('setValue',"")
							}
						}
					})	
				}
				else   //下拉框
				{
					urlArr[fieldid]=$URL+"?ClassName=web.DHCBL.MKB.MKBTermProDetail&QueryName=GetTermCmb&ResultSetType=array&base="+baseid
					$('#'+comId).combobox({ 
						//url:$URL+"?ClassName=web.DHCBL.MKB.MKBTermProDetail&QueryName=GetTermCmb&ResultSetType=array&base="+baseid,
						valueField:'MKBTRowId',
						textField:'MKBTDesc',
						delay:500,
						mode:'remote',
						comboFieldId:fieldid, //child
						onShowPanel:function(){
								var opts = $(this).combobox('options')
				         		if (opts)
				         		{
				         			$(this).combobox('setValue',"");
				         			$(this).combobox('reload',urlArr[opts.comboFieldId]);
				         		}
				         	}
					})		
				}				
			}
			else if (type=="C")  //下拉框
			{
				var newRow='<tr>'+
				   '<td class="tdlabel">'+labelName+'</td>'+
				   '<td><input id="'+comId+'" name="'+comId+'" type="text" style="width:480px;"></td>'
				'</tr>'
				$('#form-save table').append(newRow);
				//alert(configInfos)				
				var configs = configInfos.split("&%"); 
				var storeData=new Array()
				for (var j = 0; j <configs.length; j++) {
					var data={};  
					data["value"]=configs[j];  
					data["text"]=configs[j];  
					storeData.push(data)	
				}
				
				$('#'+comId).combobox({
					valueField:'value',
					textField:'text',
					data:storeData
				})			
			}
			else if (type=="R")  //单选框
			{
				//alert(configInfos)	
				var newRow='<tr><td class="tdlabel">'+labelName+'</td><td>'
				var str=""				
				var configs = configInfos.split("&%"); 				
				for (var j = 0; j <configs.length; j++) 
				{
					str=str+'<input type="radio" label="'+configs[j]+'" name="Extend'+colsField[i]+'" value="'+configs[j]+'" id="'+colsField[i]+'a'+j+'">'
				}
				newRow=newRow+str+	'</td></tr>'
				//alert(newRow)
				$('#form-save table').append(newRow);
				for (var j = 0; j <configs.length; j++) 
				{
					$('#'+colsField[i]+'a'+j).radio({
					})	
				}	

				
			}
			else if (type=="CB")
			{
				var newRow='<tr><td class="tdlabel">'+labelName+'</td><td>'
				var str=""				
				var configs = configInfos.split("&%"); 				
				for (var j = 0; j <configs.length; j++) 
				{
					str=str+'<input type="checkbox" label="'+configs[j]+'" name="Extend'+colsField[i]+'" value="'+configs[j]+'" id="'+colsField[i]+'a'+j+'">'
				}
				newRow=newRow+str+	'</td></tr>'
				//alert(newRow)
				$('#form-save table').append(newRow);
				for (var j = 0; j <configs.length; j++) 
				{
					$('#'+colsField[i]+'a'+j).checkbox({
					})	
				}				
			}
			else if(type=="SD")  //知识表达式
			{
				if (configInfos=="") return 
				var newRow='<tr>'+
				   '<td class="tdlabel">'+labelName+'</td>'+
				   '<td><input id="'+comId+'F" name="'+comId+'F" type="text" style="width:480px;"></td>'+
				'</tr>'
				$('#form-save table').append(newRow);
				$('#'+comId).validatebox()

				var newRow='<tr style="display:none">'+ 
				   '<td class="tdlabel"></td>'+
				   '<td><input id="'+comId+'" name="'+comId+'" type="text" style="width:480px;"></td>'+
				'</tr>'
				$('#form-save table').append(newRow);
				$('#'+comId+'F').validatebox()	

				//单击时生成表达式控件		
				CreatExpDom(comId,configInfos)				 
			}
			else if (type=="D")  //日期
			{
				var newRow='<tr>'+
				   '<td class="tdlabel">'+labelName+'</td>'+
				   '<td><input id="'+comId+'" name="'+comId+'" type="text" style="width:480px;"></td>'
				'</tr>'
				$('#form-save table').append(newRow);
	
				$('#'+comId).datebox({
					onShowPanel:function(){
			  			$(this).datebox('panel').click(stopPropagation)
			  		}	
				})			
			}
		}
	}
	
	//创建表达式控件
	function stopProp(e) { 
	　　if (e.stopPropagation) 
	　　　　e.stopPropagation(); 
	　　else 
	　　　　e.cancelBubble = true; 
	} 
	
	function CreatExpDom(jq2,baseId){
		var target=$('#'+jq2+'F')
		var targetf=$('#'+jq2)
		//console.log($(this))	
		target.click(function(e){
			stopProp(e);
			detailstr[jq2]=targetf.val();
			loadData(detailstr[jq2],baseId,jq2,$(this))
			if(target.offset().top+$("#knoExe").height()+35>$(window).height()){
				$("#knoExe").css({
					"top": target.offset().top-$("#knoExe").height()-25
				}).show();
			}
			else{
				$("#knoExe").css({
					"top": target.offset().top+30
				}).show();
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
				parent.document.getElementById("myWinProperty").style.display = 'none';
				addBase(baseId,jq2)	
				$("#knoExe").unbind('hide').hide("normal",function(){
					targetf.val(detailstr[jq2])
					var detail=tkMakeServerCall('web.DHCBL.MKB.MKBKnoExpression','GetDiagDesc',detailstr[jq2])
					target.val(detail)
				})
			})
			$(".knowledgeclass").next().find("input").focus();
		});
		
		
	}
		//datagrid列
	var columns =[[  
					{field:'MKBTPOrder',title:'操作',width:50,align:'center',  
						formatter:function(value,row,index){  
							var btn = '<a class="editcls" onclick="RemovePro('+index+')" href="#">删除</a>';  
							return btn;  
						}  
					} ,  
					{field:'MKBTPRowId',title:'RowId',width:80,sortable:true,hidden:true},
					{field:'MKBTPDesc',title:'属性名',width:150,sortable:true,editor:'validatebox'},
					{field:'MKBTPType',title:'格式',width:150,sortable:true,hidden:true},
					{field:'MKBTPShowType',title:'展示格式',width:150,sortable:true,
						formatter:function(v,row,index){  
							if(v=="C"){return "下拉框"}
							if(v=="T"){return "下拉树"}								
							if(v=="TX"){return "文本框"}
							if(v=="TA"){return "多行文本框"}
							if(v=="CB"){return "单选框"}
							if(v=="CG"){return "复选框"}	
							if(v=="G"){return "列表"}  //新增展示格式2019-06-28
						},
						editor : {
						    type: 'combobox',
							options: {
								data:[
										{value:'C',text:'下拉框'},
										{value:'T',text:'下拉树'},
										{value:'TX',text:'文本框'},
										{value:'TA',text:'多行文本框'},	
										{value:'CB',text:'单选框'},	
										{value:'CG',text:'复选框'},
										{value:'G',text:'列表'}
								],
								valueField: 'value',
								textField: 'text',
								editable:false/*,
								onShowPanel : function () {
									var ed=$("#mygrid").datagrid("getEditor",{index:activeIndex,field:"MKBTPShowType"});
									var rows = $('#mygrid').datagrid('getRows');//获得所有行
									var row = rows[activeIndex];//根据index获得其中一行。
									var activeType=row.MKBTPType	
									var activeId=row.MKBTPRowId
									data=GetShowTypeData(activeType,activeId)
									$(ed.target).combobox('loadData',data);

								}*/	
								
								
							}
						}
					},
					{field:'MKBTPTreeNode',title:'定义节点',width:150,sortable:true,
						formatter:function(value,row,index){
							var showvalue=value
							if ((row.MKBTPTOrP=="T")||(row.MKBTPTOrP=="ST"))  //术语
							{
								showvalue=tkMakeServerCall("web.DHCBL.MKB.MKBTerm","GetDesc",value)
							}
							else  //属性
							{
								showvalue=tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDesc",value)
							}
							//alert(v+"^"+showvalue)
							return showvalue						
						},
						editor : {
						    type: 'combotree',
							options: {
								//url:PRO_TREE_COMBO_URL,
								valueField: 'id',
								textField: 'text',
								//panelHeight : 'auto',
								panelWidth:300,
								onBeforeExpand:function(node){
									$(this).tree('expandFirstChildNodes',node)
					        	},
								onHidePanel:function(){
									if($(this).combo('getText')==""){
										$(this).combo('setValue',"")
									}
								}
							}
							
						}
					},
					{field:'MKBTPChoice',title:'单选/复选',width:150,sortable:true,
						formatter:function(v,row,index){  
							if(v=="D"){
								return "多选"
							}
							else{
								return "单选"
							}
						},
						editor : {
						    type: 'combobox',
							options: {
								data:[
										{value:'S',text:'单选'},
										{value:'D',text:'多选'}
								],
								valueField: 'value',
								textField: 'text',
								editable:false														
							}
						}
					},
					{field:'MKBTPRequired',title:'是否必填',width:150,sortable:true,
						formatter:function(v,row,index){  
							if(v=="Y"){
								return "必填"
							}
							else{
								return "不必填"
							}
						},
						editor : {
						    type: 'combobox',
							options: {
								data:[
										{value:'Y',text:'必填'},
										{value:'N',text:'不必填'}
								],
								valueField: 'value',
								textField: 'text',
								editable:false														
							}
						}
					},
					{field:'MKBTPTOrP',title:'标识',width:80,sortable:true,
					     formatter:function(v,row,index){  
							if(v=="T"){
								return "私有属性"
							}
							else if(v=="ST"){
								return "公有属性"
							}
							else{
								return "属性"
							}					
						}}
				]];
				
	//列表datagrid
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.MKB.MKBTermProDetail",
			QueryName:"GetSelPropertyList",
			property:property
		},
		columns:columns,
		pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏
		singleSelect:gridSingleSelect,
		idField:'MKBTPOrder', 
		toolbar:'#mytbar',
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		onClickCell:function(index, field, value){
		
			//改变上移下移按钮状态
			changeUpDownStatus(index);
		},
		onLoadSuccess:function(data){
			//$(".pagination-page-list").hide();
			//设置删除按钮图标
			$('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'}); 
			$(this).datagrid('clearSelections'); 
		},
		onBeforeEdit:function(rowIndex,rowData){	
			//activeId=rowData.MKBTPRowId
			$('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'}); 
			changeflag=""

		},
		onAfterEdit:function(rowIndex,rowData,changes){
			if((changes.MKBTPTreeNode!=undefined)||(changes.MKBTPShowType!=undefined)||(changes.MKBTPChoice!=undefined)||(changes.MKBTPRequired!=undefined))
			{
				changeflag="Y"
				EmptyText();
				//SaveFunLib();	
			}			
		},
		onDblClickRow:function(rowIndex,rowData){
			if(activeIndex!==""){
			   $(this).datagrid('endEdit', activeIndex);
			}
			$(this).datagrid('beginEdit', rowIndex);
			$(this).datagrid('selectRow', rowIndex);
			activeIndex=rowIndex;	
			
			//改变上移下移按钮状态
			changeUpDownStatus(rowIndex);
			
			//加载定义节点的数据
			//解决定义节点一开始显示为数字的问题
			//$(".combo").prev().combobox("showPanel");	
											
			var rows = $('#mygrid').datagrid('getRows');//获得所有行
			var row = rows[activeIndex];//根据index获得其中一行。
			var activeType=row.MKBTPType  //格式
			var activeId=row.MKBTPRowId   //术语或者属性rowid
			var activeTOrP=row.MKBTPTOrP
			
			//加载定义节点的数据
			var edTreeNode =  $("#mygrid").datagrid("getEditor",{index:activeIndex,field:"MKBTPTreeNode"});	
			if (activeType=="T")  //树形的才可以定义节点
			{
				var treeNodeUrl=""
				if ((activeTOrP=="T")||(activeTOrP=="ST"))  //属性
				{
					treeNodeUrl=TERM_TREE_COMBO_URL+"&base="+activeId
					
				}
				else
				{
					treeNodeUrl=PRO_TREE_COMBO_URL+"&property="+activeId
					
				}
				$(edTreeNode.target).combotree('reload',treeNodeUrl);
			}
			
			//加载展示格式的数据
			var edShowType=$("#mygrid").datagrid("getEditor",{index:activeIndex,field:"MKBTPShowType"});
			var showTypeData=GetShowTypeData(activeType,activeId,activeTOrP)
			$(edShowType.target).combobox('loadData',showTypeData);
			
			//控制属性名是否可编辑
			var edDesc=$("#mygrid").datagrid("getEditor",{index:activeIndex,field:"MKBTPDesc"});
			if (activeTOrP!="T")
			{
				edDesc.target.prop('readonly', true);
			}
			
		}
		
	  
	});	

	//*********主界面的按钮**************/
	//属性上移按钮
	$("#btnUp").click(function (e) { 
		OrderFunLib("up");
	}) 	
	//属性下移按钮
	$("#btnDown").click(function (e) { 
		OrderFunLib("down");
	}) 
	
	//重置按钮
	$("#btnRefresh").click(function (e) { 
		ClearFunLib();
	 }) 
 
	//保存按钮
	$("#save_btn").click(function (e) { 
		SaveFunLib();
	}) 
	
	//删除按钮
	$("#del_btn").click(function (e) { 
		DelData();
	})  
	
	//新增属性按钮
	$("#btnAddPro").click(function (e) {
		TopListWin();
	}) 
	
	//引用部位按钮
	$("#btnAddPart").click(function (e) {
		AddTermFun();
	})
	
	//引用病因按钮
	$("#btnAddPath").click(function (e) {
		AddTermFun();
	})	
	
	//新增常用模板项——分型
	$("#btnAddTypeItem").click(function (e) { 
		AddComTemplete("Type")
	})  
	//新增常用模板项——通用描述
	$("#btnAddGenItem").click(function (e) { 
		AddComTemplete("GenDesc")
	})  
	//新增常用模板项——病因
	$("#btnAddPathItem").click(function (e) { 
		AddComTemplete("Pathogeny")
	})  
	//新增常用模板项——部位
	$("#btnAddPartItem").click(function (e) { 
		AddComTemplete("Part")
	})  
	//新增常用模板项——左右
	$("#btnAddLRItem").click(function (e) { 
		AddComTemplete("LR")
	})  
	//新增常用模板项——私有病因
	$("#btnAddPriPathItem").click(function (e) { 
		AddComTemplete("PrivatePath")
	})  
	//新增常用模板项——私有部位
	$("#btnAddPriPartItem").click(function (e) { 
		AddComTemplete("PrivatePart")
	}) 
	
	//清除编辑状态——部位病因-相关诊断-批处理前需调用
	ClearEditStates=function(){
		if(activeIndex!==""){
		   $("#mygrid").datagrid('endEdit', activeIndex);
		}
		activeIndex = "";  //正在编辑的行index
	}
	
	//引用部位和引用病因按钮触发的方法
	AddComTemplete=function(itemType)
	{
		var comTempleteInfo = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetComTempleteInfo",itemType,property);  //常用模板项信息
		if (comTempleteInfo!="")
		{
			if(activeIndex!==""){
			   $("#mygrid").datagrid('endEdit', activeIndex);
			}
			var templeteInfo = comTempleteInfo.split("&"); 
			//alert(configStr)
			$("#mygrid").datagrid("insertRow", {
						index: 0,
						row:{
							MKBTPOrder:CreateIdIndex(),
							MKBTPRowId:templeteInfo[0],
							MKBTPDesc:templeteInfo[7],
							MKBTPType:templeteInfo[6],
							MKBTPShowType:templeteInfo[1],
							MKBTPTreeNode:templeteInfo[2],
							MKBTPChoice:templeteInfo[3],
							MKBTPRequired:templeteInfo[4],
							MKBTPTOrP:templeteInfo[5]
						}
					});
			var rows = $('#mygrid').datagrid("getRows");
			$('#mygrid').datagrid("loadData", rows);
			$('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  //操作列显示删除按钮
			//给缺省展示效果赋值
			EmptyText();	
		}
	
	}
	
	//引用部位和引用病因按钮触发的方法
	AddTermFun=function()
	{
		$.messager.defaults = { ok: "是", cancel: "否" };
		$.messager.confirm('提示', '是否还需要增加对通用描述的引用?', function(r){
			var partRtn = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","AddPartToDiaTemplate",property,addTermId);
			if (r){	
				var genRtn = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","AddPartToDiaTemplate",property,"");
			}
			var partRtn=eval('('+partRtn+')'); 
			if (partRtn.success == "true") {										
				$.messager.popover({msg: '引用成功!',type:'success',timeout: 1000}); 	
				ClearFunLib();
			}else {
				var errorMsg=partRtn.errorinfo+'引用失败!'
				$.messager.alert('操作提示',errorMsg,"error");
			}	
		});		
	}
	
	//预览按钮
	var previewWin
	$("#btnPreview").click(function (e) {
		var newOpenUrl="../csp/dhc.bdp.mkb.mkbtermdiagtempl.csp?MKBTRowId="+termRowId
		if ('undefined'!==typeof websys_getMWToken){
			newOpenUrl += "&MWToken="+websys_getMWToken()
		}
		//previewWin =window.open(newOpenUrl, 'newwindow', 'height=500, width=880, top=200, left=200, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no')			
        var $parent = self.parent.$;
		previewWin=$parent("#myWinGuideImage").window({
            width:winwidth-500,
            height: winheight-100,
            modal:true,
            iconCls:'icon-w-paper',
            title:"诊断模板预览",
            content:'<iframe id="timeline" frameborder="0" src="'+newOpenUrl+'" width="99%" height="98%" scrolling="no"></iframe>'
        });
         previewWin.show();

	}) 
	
	//用于单击非grid行保存可编辑行
	/*$(document).bind('click',function(){ 
	    //previewWin.close()
		if(activeIndex!==""){  //如果有正在编辑行
			if(activeIndex!==""){
			   $("#mygrid").datagrid('endEdit', activeIndex);
			}
			if(changeflag=="Y")  //如果改动标识为Y
			{
				EmptyText();
				SaveFunLib();
			}
		}
	});*/
	
	//*********新增属性弹框的按钮**************/
    //属性/术语
	$("#TextType").combobox({
		data:[
				{value:'P',text:'属性'},
				{value:'T',text:'术语'}
		],
		valueField: 'value',
		textField: 'text',
		value:"P",
		editable:false,
	    onSelect: function(record){
			ProSearch();
	    }
	})
	        	
	//属性搜索按钮
	/*$('#TextDesc').searchbox({
		searcher:function(value,name){
			ProSearch();
		}
	});*/
    $("#TextDesc").keyup(function(){
     	ProSearch();
    });
    //检索框单击选中输入内容
	$('#TextDesc').bind('click',function(){
		$('#TextDesc').select()         
	 });	
	 
	//属性重置按钮
	$("#btnProReset").click(function (e) { 
		ProReset();
	}) 	
	//属性保存按钮
	$("#btnProSave").click(function (e) { 
		ProSave();
	}) 		 

	//获取展示类型下拉框的数据
	GetShowTypeData = function(type,clickRowId,isTOrP)
	{
		var storeData=new Array()
		//列表型
		var storeDataList=[ 
							{value:'C',text:'下拉框'},
							{value:'CB',text:'单选框'},	
							{value:'CG',text:'复选框'},
							{value:'G',text:'列表'}]
		
		//树型
		var storeDataTree=[{value:'T',text:'下拉树'}]
		
		//文本型
		var storeDataText=[{value:'TX',text:'文本框'},
						   {value:'TA',text:'多行文本框'}]

		if(type=="L") {  //列表型 默认下拉框
			if (isTOrP=="T")
			{
				storeData=storeDataTree
			}
			else
			{
				storeData=storeDataList
			}
			
			/*var catFlag=tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetPropertyFlag",clickRowId);
			if (catFlag=="S")  //有诊断展示名标识的属性展示格式设置为下拉框
			{
				storeData=[{value:'C',text:'下拉框'}]
			}*/
			
		}
		else if (type=="T") //树型或引用单节点型 默认下拉树
		{
			storeData=storeDataTree
		}
		else if (type=="P") //引用属性型 默认下拉框
		{
			storeData=storeDataList
		}
		else if (type=="SS") //引用起始节点类型
		{
			storeData=storeDataTree
		}
		else if (type=="S")  //引用型 
		{
			var listOrTree=tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetProListOrTree",clickRowId);
			if (listOrTree=="T"){  //引用树形属性  默认下拉树
				storeData=storeDataTree
			}else{               //引用列表型属性  默认下拉框
				storeData=storeDataList
			}
		}
		else  //文本型 默认文本
		{
			storeData=storeDataText
		}
		return storeData;
		
	}
	
	//获取默认展示类型
	GetDefaultShowType = function(type,clickRowId,isTOrP)
	{
		var showType=""
		if(type=="L") {  //列表型 默认列表   
			if (isTOrP=="T")
			{
				showType="T"
			}
			else
			{
				showType="G"
			}
		}
		else if (type=="T") //树型 默认下拉树
		{
			showType="T"
		}
		else if (type=="P") //引用属性型 默认下拉框
		{
			showType="C"
		}
		else if (type=="SS") //引用起始节点型
		{
			showType="T"
		}
		else if (type=="S") //引用型 
		{
			var listOrTree=tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetProListOrTree",clickRowId);
			if (listOrTree=="T"){  //引用树形属性  默认下拉树
				showType="T"
			}else{               //引用列表型属性  默认列表 
				showType="G"
			}
		}
		else  //文本型 默认文本
		{
			showType="TX"	
		}
		return showType;
		
	}
	
	 //获取所有已选属性的信息(multi为空时获取mygrid的所有行，如果muliti不为空则获取选中行)
	GetChoseProStr=function(multi)
	{
		var ids = [];
		var datas
		if (multi!="")
		{
			datas=$('#mygrid').datagrid('getSelections');
			
		}
		else
		{
			datas=$('#mygrid').datagrid('getRows');
		}
		
		for(var i=0; i<datas.length; i++){
			var str=datas[i].MKBTPRowId+"&"+datas[i].MKBTPShowType
			var treeNode=datas[i].MKBTPTreeNode     //定义节点  
			var choiceType=datas[i].MKBTPChoice    //单选、多选  S/D
			var isRequired=datas[i].MKBTPRequired  //是否必填  Y/N
			var isTOrP=datas[i].MKBTPTOrP   //术语或属性 T/P

			if(treeNode==undefined){
				treeNode=""
		    }
		    if ((choiceType==undefined)||(choiceType=="")){  //默认单选
		    	choiceType="S"			    	
		    }		   
		    if ((isRequired==undefined)||(isRequired=="")){  //默认不必填
		    	isRequired="N"
		    }
		    if ((isTOrP==undefined)||(isTOrP=="")){  //默认为属性
		    	isTOrP="P"
		    }
		    str=str+"&"+treeNode+"&"+choiceType+"&"+isRequired+"&"+isTOrP;
		    if (isTOrP=="T")
		    {
		     	str=str+"&"+datas[i].MKBTPDesc
		    }
			ids.push(str);    //id 串
		}
		var proIdsStr=ids.join(',')
		//alert(multi+"^"+datas.length+"^"+proIdsStr)
		return proIdsStr
	}
	
	
	//缺省展示格式文本框赋值
	EmptyText=function ()
	{
		if (emptycomid!="")  //如果有缺省展示格式文本框
		{
			//诊断常用名
			var diaCom=tkMakeServerCall('web.DHCBL.MKB.MKBTermProDetail','GetTermCom',property); 
			var descs = []; 
			var datas=$('#mygrid').datagrid('getRows');
			for(var i=0; i<datas.length; i++)
			{
				var desc=datas[i].MKBTPDesc  //属性名/术语名
				var treeNode=datas[i].MKBTPTreeNode  //定义节点
				var isTOrP=datas[i].MKBTPTOrP  //术语/属性
				if((treeNode!=undefined)&(treeNode!=""))  //如果定义了节点则取节点名
				{
					/*if ((isTOrP=="T")||(isTOrP=="ST")) //术语
					{
						desc=tkMakeServerCall("web.DHCBL.MKB.MKBTerm","GetDesc",treeNode)						
					}
					else  //属性
					{
						desc=tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDesc",treeNode)
					}*/
					if (isTOrP=="P")
					{
						desc=tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDesc",treeNode)
					}
				}		
				if (descs.indexOf(desc)=="-1")  //描述去重
				{
					descs.push(desc);
				}
			}
			var DiaDescs=descs.join(',')
			var emptymode=diaCom+"("+DiaDescs+")"
			$('#'+emptycomid).val(emptymode)
			//Ext.getCmp(emptycomid).setValue(emptymode)						
		}
	}
	
	///***************************************添加属性弹出框*************************/
	//未选属性列表
	InitUnProList=function()
	{
		var unProColumns=[[ 
					  { field: 'ck', checkbox: true, width: '30' },  //复选框  	
					  {field:'MKBTPDesc',title:'属性/术语',width:150}, 
					  {field:'MKBTPType',title:'格式',width:100,
						formatter:function(v,row,index){  
							if (v=="L"){return "列表"}
							if (v=="T"){return "树形";}
							if (v=="TX"){return "文本"}
							if (v=="F"){return "表单";}
							if (v=="TA"){return "多行文本"}
							if (v=="R"){return "单选框";}
							if (v=="CB"){return "复选框"}
							if (v=="C"){return "下拉框"}
							if (v=="S"){return "引用术语";}
							if (v=="P"){return "引用属性";}
							if (v=="SD"){return "引用属性内容"}
							if (v=="SS"){return "引用起始节点"}
						}
					  }, 
					  {field:'MKBTPRowId',title:'MKBTPRowId',width: '30',hidden:true},
					  {field:'MKBTPTOrP',title:'标识',width: '60',hidden:true}
					  ]];


		$('#UnProGrid').datagrid({ 
			width:'100%',
			height:'100%', 
			pagination: true, 
			pageSize:PageSizePop,
			pageList:[5,10,12,15,20,25,30,50,75,100,200,300,500,1000],
			toolbar:'#mywintbar',
			loadMsg:'数据装载中......',
			autoRowHeight: true,
			url:$URL,
			queryParams:{
				ClassName:"web.DHCBL.MKB.MKBTermProDetail",
				QueryName:"GetUnSelProList",
				property : property,
				textType: $('#TextType').combobox('getValue')
			},
			singleSelect:false,
			idField:'MKBTPRowId', 
			rownumbers:false,
			fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
			displayMsg:"",  //显示 {from} 到 {to} ,从 {total} 条记录
			remoteSort:false,
			//sortName:"EpisodeID",
			columns:unProColumns,
			//onClickRow: ClickProGrid,
			onLoadSuccess:function(data){
				//隐藏行选择数，只按默认显示15个
				//$(".pagination-page-list").hide();
			},
			onLoadError:function(){
			}
		});
	}
	

	
	//属性列表的弹出窗
	TopListWin=function()
	{
		$("#myWin").show();	
		//$("#TextDesc").searchbox('setValue', '');
		$("#TextDesc").val("");
		var myWin = $HUI.dialog("#myWin",{
			width:460,
			height:420,
			resizable:true,
			title:'新增模板项',
			iconCls:'icon-w-add',
			modal:false,  //遮盖
			buttonAlign : 'center'
			/*buttons:[{
				text:'保存',
				id:'save_pro_btn',
				handler:function(){
					ProSave();
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]*/
		});	
		InitUnProList();
	}
	
	//生成一个idIndex唯一的标识
	CreateIdIndex=function() {
		var s = [];
		var hexDigits = "0123456789";
		for (var i = 0; i < 4; i++) {
			s[i] = hexDigits.substr(Math.floor(Math.random() * 10), 1);
		}
		var uuid = s.join("")+"-u";
		return uuid;
    }
    
	//属性保存方法
	ProSave=function()
	{
		var rows = $('#UnProGrid').datagrid('getSelections');	
		//已选列表插入选中数据
		if (rows.length==0)
		{
			$.messager.alert('错误提示','没有要保存的数据!',"error");
			return;
		}
		for(var i=0; i<rows.length; i++){
			var rowid=rows[i].MKBTPRowId
			var type=rows[i].MKBTPType  //格式
			var isTOrP=rows[i].MKBTPTOrP
			var showType=GetDefaultShowType(type,rowid,isTOrP)  //展示格式
			$("#mygrid").datagrid("insertRow", {
					index: 0,
					row:{
						MKBTPOrder:CreateIdIndex(),
						MKBTPRowId:rowid,
						MKBTPDesc:rows[i].MKBTPDesc,
						MKBTPType:type,
						MKBTPShowType:showType,
						MKBTPChoice:"S",
						MKBTPRequired:"N",
						MKBTPTOrP:isTOrP
					}
				});
			$('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  //操作列显示删除按钮

		}
		var rows = $('#mygrid').datagrid("getRows");
		$('#mygrid').datagrid("loadData", rows);
		//给缺省展示效果赋值
		EmptyText();
		//SaveFunLib();
		$('#UnProGrid').datagrid('clearSelections');	
	}
	
	//移除已选属性
	RemovePro=function (index)
	{
		$('#mygrid').datagrid('selectRow',index);// 关键在这里 
		var record = $("#mygrid").datagrid("getSelected"); 
		if (record){
			//如果是新加的数据，还没保存，则只是移除
			$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
				if (r){	
					$('#mygrid').datagrid('deleteRow',index); 
					var rows = $('#mygrid').datagrid("getRows");
					$('#mygrid').datagrid("loadData", rows);
					EmptyText();  //给缺省展示效果赋值	
					if (record.MKBTPType=="SS") //如果是引用起始节点类型的属性 则删除的时候把属性也删除
					{
						if(deletePropertys!="")
						{
							deletePropertys=deletePropertys+"^"+record.MKBTPRowId
						}
						else
						{
							deletePropertys=record.MKBTPRowId
						}
					}
					/*if (rows.length==0)  //如果已选列表数据为空则执行删除操作
					{
						DelDataNoWarn();
					}
					else   //如果已选列表数据不为空则执行保存
					{
						SaveFunLib();
					}*/					
				}
			});
		}

	} 	

	 
	//属性搜索方法
	ProSearch=function()
	{
		var textType=$('#TextType').combobox('getValue');
		//var desc=$.trim($('#TextDesc').searchbox('getValue'));
		var desc=$.trim($('#TextDesc').val());
		$('#UnProGrid').datagrid('load',  {
			ClassName:"web.DHCBL.MKB.MKBTermProDetail",
			QueryName:"GetUnSelProList",			
			'desc':desc,	
			'property':property,
			'textType':textType
		});
		$('#UnProGrid').datagrid('clearSelections');		
	}
	
	//属性重置方法
	ProReset=function()
	{
		var textType=$('#TextType').combobox('getValue');
		//$("#TextDesc").searchbox('setValue', '');
		$("#TextDesc").val("");
		$('#UnProGrid').datagrid('load',  {
			ClassName:"web.DHCBL.MKB.MKBTermProDetail",
			QueryName:"GetUnSelProList",			
			'property':property,
			'textType':textType
		});
		$('#UnProGrid').datagrid('clearSelections');		
	}
	
	//重置方法
	ClearFunLib=function()
	{
		deletePropertys=""  //要删除的属性
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.MKB.MKBTermProDetail",
			QueryName:"GetSelPropertyList",
			property:property
		});
		$('#mygrid').datagrid('clearSelections')

		//上移下移按钮改为可用
		$('#btnUp').linkbutton('enable');
		$('#btnDown').linkbutton('enable');
		//代码和描述赋值
		var textInfo=tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetTextInfo",property);
		var info=textInfo.split("[A]");
		var id=info[0]  //全局变量 私有属性值表User.MKBTermProDetail的ID_"[A]"_属性内容		
		if(id!="")
		{	
			$.cm({
				ClassName:"web.DHCBL.MKB.MKBTermProDetail",
				MethodName:"NewOpenData",
				id:id,
				property:property
			},function(jsonData){
				if (extendChild!="")   //如果有单选框复选框，则给单选框复选框赋值
				{
					//给扩展属性赋值
					var colsField = extendChild.split("[N]"); 
					var typeStr = extendType.split("[N]"); 
					var configStr = extendConfig.split("[N]"); 
					for (var i = 0; i <colsField.length; i++) {
						var child=colsField[i]    //child
						var type=typeStr[i]   //格式
						var configInfos=configStr[i]  //配置项
						var comId='Extend'+colsField[i];   //控件id	
						
						if (type=="R")  //单选框 男&%女&%全部
						{
							var extendValue=jsonData[comId]
							var configs = configInfos.split("&%"); 
							for (var j = 0; j <configs.length; j++) 
							{
								if(configs[j]==extendValue)
								{
									$HUI.radio('#'+colsField[i]+'a'+j).setValue(true);
								}
								else
								{
									$HUI.radio('#'+colsField[i]+'a'+j).setValue(false);
								}
							}	
						}
						if (type=="CB")  //复选框 苹果&%香蕉&%梨
						{
							var extendValue=jsonData[comId]  //苹果,香蕉
							var configs = configInfos.split("&%"); 
							var CBValue=extendValue.split(","); 
							for (var j = 0; j <configs.length; j++) //遍历配置项 苹果&%香蕉&%梨
							{
								var CheckFlag=""  //选中标识
								for(var z=0;z<CBValue.length;z++)   //遍历扩展属性值 苹果&%梨
								{
									if(configs[j]==CBValue[z])  
									{
										CheckFlag="Y"
										break
									}
								}
								if (CheckFlag=="Y")  //选中
								{
									$HUI.checkbox('#'+colsField[i]+'a'+j).setValue(true);
								}
								else
								{
									$HUI.checkbox('#'+colsField[i]+'a'+j).setValue(false);
								}
							}					
						}
						if (type=="TA")
						{
							jsonData[comId]=jsonData[comId].replace(/<br\/>/g,"\n");    
						}
						if (type=="SD")
						{
							jsonData[comId+"F"]=tkMakeServerCall('web.DHCBL.MKB.MKBKnoExpression','GetDiagDesc',jsonData[comId])
						}
						if (type=="S")
						{
				
							if ((urlArr[child]!="")&&(urlArr[child]!=undefined)){
								var url=urlArr[child]+"&rowid="+jsonData[comId]
								$('#'+comId).combobox('reload',url);
							}
						}
						
					}
				}
				//表单赋值
				$('#form-save').form("load",jsonData);			
			});	
		}
		else
		{
			if (extendChild!="")   //如果有单选框复选框，则给单选框复选框赋值
			{
				//给扩展属性赋值
				var colsField = extendChild.split("[N]"); 
				var typeStr = extendType.split("[N]"); 
				var configStr = extendConfig.split("[N]"); 
				for (var i = 0; i <colsField.length; i++) {
					var child=colsField[i]    //child
					var type=typeStr[i]   //格式
					var configInfos=configStr[i]  //配置项
					
					if (type=="R")  //单选框 男&%女&%全部
					{
						var configs = configInfos.split("&%"); 
						for (var j = 0; j <configs.length; j++) 
						{
							$HUI.radio('#'+colsField[i]+'a'+j).setValue(false);							
						}	
					}
					if (type=="CB")  //复选框 苹果&%香蕉&%梨
					{
						var configs = configInfos.split("&%"); 
						for (var j = 0; j <configs.length; j++) //遍历配置项 苹果&%香蕉&%梨
						{
							$HUI.checkbox('#'+colsField[i]+'a'+j).setValue(false);								
						}					
					}
					
				}
			}
			//清空表单
			$('#form-save').form('clear');			
		}

	}
	ClearFunLib();

	///新增、更新
	SaveFunLib=function(nowarn)
	{	
		var id=$("#MKBTPDRowId").val()
		//结束编辑状态 （否则定义的节点保存不了）
		if(activeIndex!==""){
		   $('#mygrid').datagrid('endEdit', activeIndex);
		   activeIndex=""
		   //设置删除按钮图标
		   $('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'}); 
		}
		var MKBTPDDesc=GetChoseProStr("");
		//alert(MKBTPDDesc)
		if ((MKBTPDDesc=="")&(id==""))  //如果是新增且列表数据为空，则不能保存
		{
			$.messager.alert('错误提示','列表数据不能为空!',"error");
			return;
		}
		EmptyText();  //给缺省展示效果赋值
		var extendValue=""
		if (extendChild!="")   //如果有扩展属性
		{
			var colsField = extendChild.split("[N]"); 
			var typeStr = extendType.split("[N]"); 
			var configStr = extendConfig.split("[N]"); 
			for (var i = 0; i <colsField.length; i++) 
			{
				var id="#Extend"+colsField[i]
				var type=typeStr[i]
				var child=colsField[i]
				var extProValue=""			
				if (type=="TX")
				{
					extProValue=$.trim($(id).val())
				}
				else if (type=="TA")
				{
					extProValue=$.trim($(id).val())
				}
				else if(type=="S")  //引用
				{
					var configInfos=configStr[i]
					if (configInfos!="")
					{
						var baseInfo = configInfos.split("&%"); 
						var baseid=baseInfo[0]   //术语库注册id
						var baseType=baseInfo[1]   //术语库类型
						if (baseType=="T")  //下拉树			
						{
							extProValue=$(id).combotree('getValue')
						}
						else  //下拉框
						{
							extProValue=$(id).combobox('getValue')
						}
					}
				}
				else if(type=="C")  //下拉框
				{
					extProValue=$(id).combobox('getValue')
				}
				else if(type=="R")  //单选框
				{
					var radioName="Extend"+colsField[i]
					// 获得选中的值
					var checkedRadioJObj = $("input[name='"+radioName+"']:checked");
					extProValue=checkedRadioJObj.val()
				}
				else if(type=="CB")  //复选框
				{
					var comboboxName="Extend"+colsField[i]
					// 获得选中的值
					var checkBoxArr = [];  
					$("input[name='"+comboboxName+"']:checked").each(function() {  
						checkBoxArr.push($(this).val());  
					});  
					extProValue=checkBoxArr.join('&%');  //数组按指定格式拼串
				}
				else if(type=="SD")
				{
					if($(id+"F").val()!="")
					{
						extProValue=$.trim($(id).val())
					}
				}
				else if(type=="D")
				{						
					extProValue=$(id).datebox('getValue');
				}
				
				if ((extProValue=="undefined")||(extProValue==null)){extProValue=""}
				if (extendValue!="")
				{
					var extendValue=extendValue+"[N]"+child+"[A]"+extProValue
				}
				else
				{
					var extendValue=child+"[A]"+extProValue
				}	
			}
		}
		//alert(extendValue)
		//如果列表不为空则保存
		if (MKBTPDDesc!="")
		{		
			$('#form-save').form('submit', { 
				url: SAVE_ACTION_URL, 
				onSubmit: function(param){
					param.MKBTPDRowId = $("#MKBTPDRowId").val(),
					param.MKBTPDProDR=property,
					param.MKBTPDDesc=MKBTPDDesc,
					param.MKBTPDExtend=extendValue
				},
				success: function (data) { 
					  var data=eval('('+data+')'); 
					  if (data.success == 'true') {
					  		$("#MKBTPDRowId").val(data.id);
							if (nowarn!=1)   //上移下移不提示
							{
								$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
							}
							if (deletePropertys!="")
							{
								var deleteRes=tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","DeletePropertys",deletePropertys);
							}
							ClearFunLib();
	
					  } 
					  else { 
					  		if (nowarn!=1)   //上移下移不提示
							{
								var errorMsg ="保存失败！"
								if (data.errorinfo) {
									errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
								}
								$.messager.alert('操作提示',errorMsg,"error");
							}
			
					}
	
				} 
			});
		}
		else  //如果列表为空则删除
		{
			$.ajax({
					url:DELETE_ACTION_URL,  
					data:{
						"id":$("#MKBTPDRowId").val()    ///rowid
					},  
					type:"POST",   
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
									$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
									ClearFunLib();
							  } 
							  else { 
									var errorMsg ="保存失败！"
									$.messager.alert('操作提示',errorMsg,"error");
					
							}			
					}  
				})
			
		}



	}

	///删除
	DelData=function()
	{        
		var id=$("#MKBTPDRowId").val()
		if (id=="") 
		{
			/*$.messager.show({ 
						  title: '提示消息', 
						  msg: '没有内容数据', 
						  showType: 'show', 
						  timeout: 1000, 
						  style: { 
							right: '', 
							bottom: ''
						  } 
						}); */
			$.messager.popover({msg: '没有要删除的内容！',type:'info',timeout: 1000});

		}
		else
		{
			$.messager.confirm('提示', '确定要删除全部数据吗?', function(r){
				if (r){	
					$.ajax({
						url:DELETE_ACTION_URL,  
						data:{
							"id":id     ///rowid
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
	}
	
	///删除数据且没有提示,用于删除已选列表的最后一条数据时
	DelDataNoWarn=function()
	{        
		var id=$("#MKBTPDRowId").val()
		if (id!="") 
		{
			$.ajax({
				url:DELETE_ACTION_URL,  
				data:{
					"id":id     ///rowid
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
								$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
								ClearFunLib();
						  } 
						  else { 
								var errorMsg ="提交失败！"
								if (data.info) {
									errorMsg =errorMsg+ '<br/>错误信息:' + data.info
								}
								$.messager.alert('操作提示',errorMsg,"error");
				
						}			
				}  
			})
		}

	}
	
	//改变上移下移按钮状态
	changeUpDownStatus=function(rowIndex)
	{
		if(rowIndex==0){
			$('#btnUp').linkbutton('disable');
		}else
		{
			$('#btnUp').linkbutton('enable');
		}
		var rows = $('#mygrid').datagrid('getRows');
		if ((rowIndex+1)==rows.length){
			$('#btnDown').linkbutton('disable');
		}else
		{
			$('#btnDown').linkbutton('enable');
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
		EmptyText();  //给缺省展示效果赋值	
		//SaveFunLib(1);
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

};
$(init);
