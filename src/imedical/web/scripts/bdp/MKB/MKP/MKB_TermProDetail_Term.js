/// 名称: 医用知识库 -引用属性格式的属性内容维护
/// 描述: 包含增删改上移下移等功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2018-04-03

var init = function(){

	var HISUI_SQLTableName="MKB_TermProDetail"+property,HISUI_ClassTableName="User.MKBTermProDetail"+property;
	
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=DeleteData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=SaveData&pEntityName=web.Entity.MKB.MKBTermProDetail";
	var TREE_COMBO_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetJsonDataForCmb"
	//var property=1
	var activeIndex="";   //正在编辑行的行号
	//var activeId=""     //正在编辑行的id
	var proConfigInfos = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetProConfigInfo",property)  //配置项信息
	var proConfigInfo=proConfigInfos.split("^")  
	var configBaseId = proConfigInfo[0];   //术语库注册id
	var configBaseType = proConfigInfo[1];  //术语库注册类型L/T
	
	//获取扩展属性信息	
	var extendInfo=tkMakeServerCall('web.DHCBL.MKB.MKBTermProDetail','getExtendInfo',property);
	var extend=extendInfo.split("[A]")
	var propertyName = extend[0];  //主列名
	var extendChild =extend[1];  //扩展属性child串
	var extendTitle =extend[2];  //扩展属性名串
	var extendType =extend[3];    //扩展属性格式串
	var extendConfig =extend[4];    //扩展属性配置项串
	
	//缺省展示效果的id,用于缺省展示效果文本框内容的自动生成
	var emptycomid=""

	if (extendChild!="")   //如果有扩展属性，则自动生成列
	{
		var colsField = extendChild.split("[N]"); 
		var colsHead = extendTitle.split("[N]"); 
		var typeStr = extendType.split("[N]"); 
		var configStr = extendConfig.split("[N]"); 
		//alert(configStr)
		for (var i = 0; i <colsField.length; i++) {

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
				   '<td><input id="'+comId+'" name="'+comId+'" type="text" style="width:300px;"></td>'+
				'</tr>'
				$('#form-save table').append(newRow);
				$('#'+comId).validatebox()
			}
			else if(type=="TA")  //多行文本框
			{
				var newRow='<tr>'+
				   '<td class="tdlabel">'+labelName+'</td>'+
				   '<td><textarea id="'+comId+'" name="'+comId+'" type="text" style="height:100px;width:300px;"></td>'+
				'</tr>'
				$('#form-save table').append(newRow);
				$('#'+comId).validatebox()		
			}
			else if(type=="S")  //引用  注意：要换成MKBTerm，同时还要判断是列表下拉框还是树形下拉框
			{			
				if (configInfos=="") return 
				var newRow='<tr>'+
				   '<td class="tdlabel">'+labelName+'</td>'+
				   '<td><input id="'+comId+'" name="'+comId+'" type="text" style="width:300px;"></td>'
				'</tr>'
				$('#form-save table').append(newRow);
				var baseInfo = configInfos.split("&%"); 
				var baseid=baseInfo[0]   //术语库注册id
				var baseType=baseInfo[1]   //术语库类型
				if (baseType=="T")  //下拉树			
				{
					$('#'+comId).combotree({ 
						url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmb&base="+baseid
					})	
				}
				else   //下拉框
				{
					$('#'+comId).combobox({ 
						url:$URL+"?ClassName=web.DHCBL.MKB.MKBTerm&QueryName=GetList&ResultSetType=array&base="+baseid,
						valueField:'MKBTRowId',
						textField:'MKBTDesc'
					})		
				}				
			}
			else if (type=="C")  //下拉框
			{
				var newRow='<tr>'+
				   '<td class="tdlabel">'+labelName+'</td>'+
				   '<td><input id="'+comId+'" name="'+comId+'" type="text" style="width:300px;"></td>'
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
		}
	}
	
	//datagrid列
	var columns =[[  
					{field:'opt',title:'操作',width:50,align:'center',  
						formatter:function(value,row,index){  
							var btn = '<a class="editcls" onclick="RemoveTerm('+index+')" href="#">删除</a>';  
							return btn;  
						}  
					} ,  
					{field:'MKBTRowId',title:'RowId',width:80,sortable:true,hidden:true},
					{field:'MKBTDesc',title:'描述',width:150,sortable:true},
					{field:'MKBTCode',title:'代码',width:150,sortable:true}
				]];
				
	//列表datagrid
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.MKB.MKBTermProDetail",
			QueryName:"GetSelTermList",
			property:property
		},
		columns:columns,
		pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏
		singleSelect:true,
		idField:'MKBTRowId', 
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		onLoadSuccess:function(data){
			//$(".pagination-page-list").hide();
			//设置删除按钮图标
			$('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'}); 
		},
		onDblClickRow:function(rowIndex,rowData){
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
		},
		onClickRow:function(rowIndex,rowData){
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
			  
	});	

	 //获取所有已选属性的信息
	GetChoseTermStr=function()
	{
		var ids = [];
		var datas=$('#mygrid').datagrid('getRows');
		for(var i=0; i<datas.length; i++){
			var str=datas[i].MKBTRowId	
			ids.push(str);    //id 串
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
			pageSize:20,
			pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
			//toolbar:'#probar',
			fitColumns: false,
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
		var desc=$.trim($('#TextDesc').searchbox('getValue'));
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
		$("#TextDesc").searchbox('setValue', '');
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
		var deleteRows = []; 
		var rows = $('#UnSelGrid').datagrid('getSelections');	
		//已选列表插入选中数据
		for(var i=0; i<rows.length; i++){
			deleteRows.push(rows[i]);		
			$("#mygrid").datagrid("appendRow", {
					opt:'',
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
	
	//移除已选属性
	RemoveTerm=function (index)
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
					if (rows.length==0)  //如果已选列表数据为空则执行删除操作
					{
						DelDataNoWarn();
					}
					else   //如果已选列表数据不为空则执行保存
					{
						SaveFunLib();
					}					
					if($('#myWin').is(":visible"))  //如果新增治疗手术窗口打开了，则点删除后刷新未选治疗手术列表
					{
						TermReset();
					}					
				}
			});
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
		//设置删除按钮图标
		$('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'}); 
		SaveFunLib();
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

	//术语分类检索框
	$("#treeWin").keyup(function(){ 
		var str = $("#FindTreeText").val(); 
		findByRadioCheck("catTree",str,$("input[name='FilterCK']:checked").val())
		
	})
	//术语分类全部、已选、未选
	$HUI.radio("#treeWin [name='FilterCK']",{
        onChecked:function(e,value){
        	findByRadioCheck("catTree",$("#FindTreeText").val(),$(e.target).attr("value"))
       }
    });
	
 	//引用树型属性的弹出窗
	TopTreeWin=function() 
	{ 
	 	$("#treeWin").show();
		$HUI.tree('#catTree',{
			url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermBase&pClassMethod=GetCatJsonData&base="+configBaseId,
			lines:true,  //树节点之间显示线条
			autoSizeColumn:false,
			checkbox:true,
			cascadeCheck:false,  //是否级联检查。默认true  菜单特殊，不级联操作
			animate:false,   //是否树展开折叠的动画效果
			onLoadSuccess:function(data){
				var catStr=GetChoseTermStr();
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
				}
			}
			
		});
		$HUI.radio("#myChecktreeFilterCK0").setValue(true)  //初始设置为全部
		$("#FindTreeText").val("")
		      
		var treeWin = $HUI.dialog("#treeWin",{
			resizable:true,
			title:'添加术语条目',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				id:'save_tree_btn',
				handler:function(){
					var termStr=GetSearchTermStr();  //已选的术语
					var strCatId = "",strCatText = "";
					var nodes = $('#catTree').tree('getChecked');
					//已选列表插入选中数据
	                for (var i = 0; i < nodes.length; i++) {
						var ids="<"+nodes[i].id+">"
						if (termStr.indexOf(ids)<0)  //已选列表里没有则插入
						{
							var MKBTCode=tkMakeServerCall('web.DHCBL.MKB.MKBTerm','getTermCodeByID',nodes[i].id);
							$("#mygrid").datagrid("appendRow", {
								opt:'',
								MKBTRowId:nodes[i].id,
								MKBTDesc:nodes[i].text,
								MKBTCode:MKBTCode
							});
						}
						$('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  //操作列显示删除按钮
	                }
					//$("#MKBTBCatDr").val(strCatId)
					treeWin.close();
					SaveFunLib();
				}
			},{
				text:'关闭',
				handler:function(){
					treeWin.close();
				}
			}]
		});	
		var node= $('#catTree').find(2)
		$('#catTree').tree('check',node.target) 
	}
 
 	//引用列表型属性的弹出窗
	TopListWin=function() 
	{ 
		$("#TextDesc").searchbox('setValue', '');
		$('#myWin').window({ 
			 title:"术语列表",
			 minimizable:false,
			 maximizable:false,
			 collapsible:false,
			 modal:false //modal-boolean定义窗口是不是模态（modal）窗口-true
		});
		InitUnSelList();
	}
	
	//新增属性按钮
	$("#btnAddTerm").click(function (e) { 
		if (configBaseType=="T"){
			TopTreeWin();
		}
		else{
			TopListWin();
		}
	 }) 
	 	
		
	//属性搜索按钮
	$('#TextDesc').searchbox({
		searcher:function(value,name){
			TermSearch();
		}
	});

	//属性重置按钮
	$("#btnTermReset").click(function (e) { 
		TermReset();
	}) 	
	//属性保存按钮
	$("#btnTermSave").click(function (e) { 
		TermSave();
	}) 

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
 
 
	//添加按钮
	$("#save_btn").click(function (e) { 
		SaveFunLib();
	}) 
	
	//删除按钮
	$("#del_btn").click(function (e) { 
		DelData();
	})  
	
	//重置方法
	ClearFunLib=function()
	{
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.MKB.MKBTermProDetail",
			QueryName:"GetSelTermList",
			property:property
		});
		$('#mygrid').datagrid('unselectAll')
		//清空表单
		$('#form-save').form('clear');
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
				MethodName:"OpenData",
				id:id
			},function(jsonData){
				if (extendChild!="")   //如果有扩展属性
				{
					//给扩展属性赋值
					var colsField = extendChild.split("[N]"); 
					var typeStr = extendType.split("[N]"); 
					var configStr = extendConfig.split("[N]"); 
					for (var i = 0; i <colsField.length; i++) {
						var child=colsField[i]    //child
						var type=typeStr[i]   //格式
						var configInfos=configStr[i]  //配置项
						var extendValue=tkMakeServerCall('web.DHCBL.MKB.MKBTermProDetail','getExtendValue',id,property,child);
						if (type=="TX")
						{
							$('#Extend'+child).val(extendValue)
						}
						else if (type=="TA")
						{
							$('#Extend'+child).val(extendValue)
						}
						else if(type=="S")  //引用
						{

							if (configInfos=="") return 
							var baseInfo = configInfos.split("&%"); 
							var baseType=baseInfo[1]   //术语库类型
							if (baseType=="T")  //引用下拉树
							{
								$('#Extend'+child).combotree('setValue',extendValue)
							}
							else //引用下拉框
							{
								$('#Extend'+child).combobox('setValue',extendValue)
							}
						}
						else if (type=="C")  //下拉框
						{
							$('#Extend'+child).combobox('setValue',extendValue)
						}
						else if (type=="R")  //单选框 男&%女&%全部
						{
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
						else if (type=="CB")  //复选框 苹果&%香蕉&%梨
						{
							var configs = configInfos.split("&%"); 
							var CBValue=extendValue.split("&%"); 
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
						
					}
				}
				
				//表单赋值
				$('#form-save').form("load",jsonData);			
			});	
		}
	}
	ClearFunLib();

	///新增、更新
	SaveFunLib=function()
	{	
		var MKBTPDDesc=GetChoseTermStr();
		if (MKBTPDDesc=="")
		{
			$.messager.alert('错误提示','列表数据不能为空!',"error");
			return;
		}
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
	DelData=function()
	{        
		var id=$("#MKBTPDRowId").val()
		if (id=="") 
		{
			$.messager.show({ 
						  title: '提示消息', 
						  msg: '没有内容数据', 
						  showType: 'show', 
						  timeout: 1000, 
						  style: { 
							right: '', 
							bottom: ''
						  } 
						}); 
		}
		else
		{
			$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
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
										$.messager.show({ 
										  title: '提示消息', 
										  msg: '删除成功', 
										  showType: 'show', 
										  timeout: 1000, 
										  style: { 
											right: '', 
											bottom: ''
										  } 
										}); 
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
	
};
$(init);
