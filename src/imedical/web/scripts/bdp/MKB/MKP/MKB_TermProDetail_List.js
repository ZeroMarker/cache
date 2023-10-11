/// 名称: 医用知识库 -列表型属性内容维护
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2018-03-30

var init = function(){

	var HISUI_SQLTableName="MKB_TermProDetail",HISUI_ClassTableName="User.MKBTermProDetail"+property;
	
	var DELETE_ALL_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=DeleteAllSelTerm";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=DeleteData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=SaveData&pEntityName=web.Entity.MKB.MKBTermProDetail";
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetMyList";
	//var property=1
	//获取扩展属性信息	
	var extendInfo=tkMakeServerCall('web.DHCBL.MKB.MKBTermProDetail','getExtendInfo',property);
	var extend=extendInfo.split("[A]")
	var propertyName = extend[0];  //主列名
	if (propertyName==""){propertyName="中心词"}
	var extendChild =extend[1];  //扩展属性child串
	var extendTitle =extend[2];  //扩展属性名串
	var extendType =extend[3];    //扩展属性格式串
	var extendConfig =extend[4];    //扩展属性配置项串
	var termBase =extend[5];    //术语所属术语库id
	var termRowId =extend[6];    //术语id
	var termCom =extend[7];    //术语描述——表达式控件所需代码
	
	var editIndex = undefined;  //正在编辑的行index
	var rowsvalue=undefined;   //正在编辑的行数据
	var oldrowsvalue=undefined;  //上一个编辑的行数据
	var preeditIndex="";     //上一个编辑的行index
    var expressInfoArr=[]   //表达式控件信息串
	var textareInfoArr=[]  //多行文本框信息串
	var sourseInfoArr=[]  //引用信息串
	var urlArr=[]   //url信息
	var showNameChild="" //展示名child
	
	//表达式控件所需代码
	var cbg=null;//诊断表达式combogrid
	var searchNameCondition=""; //诊断表达式检索条件
	var SelMRCICDRowid=""; //诊断查找下拉框的诊断id
	var SecondLoad=0
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
    
    //诊断表达式下拉框
	var DisplayNameEditor={
		type:'combogrid',
		options:{
				panelWidth:380,
				panelHeight:240, //308
				delay: 500,    
				mode: 'remote',  
				//url:$URL+"?ClassName=web.DHCBL.MKB.MKBTermProDetail&MethodName=GetTermListForDoc&base=5",
				showHeader:false,
				fitColumns: false,   
				striped: true,   
				editable:true,   
				selectOnNavigation:false,
				rownumbers:false,//序号   
				collapsible:false,//是否可折叠的   
				fit: false,//自动大小   
				pagination : true,//是否分页   
				pageSize: 6,//每页显示的记录条数，默认为10   
				pageList: [6,8,15,30,100,300],//可以设置每页记录条数的列表   
				showPageList:false,
				method:'post', 
				idField: 'MKBTRowId',    
				textField: 'MKBTDesc',    
				columns: [[    
					{field:'MKBTDesc',title:'诊断名称',width:480,sortable:true,
						formatter:function(value,rec){ 
						    var tooltipText=value.replace(/\ +/g,"")
					    	var reg = new RegExp("[\\u4E00-\\u9FFF]+","g");
　　							var matchCondition=""
							if ((findCondition!="")&&(findCondition!=undefined)){
								if(reg.test(findCondition)){   //包含中文情况
								    matchCondition=findCondition
								}else{ //不含中文情况
								 	var pinyin=Pinyin.GetJPU(value)
								 	var indexSign=value.indexOf("(")
								 	pinyin=pinyin.substring(0,indexSign)+"("+pinyin.substring(indexSign,pinyin.length)+")" //拼音拼上括号
								 	var indexCondition=pinyin.indexOf(findCondition.toUpperCase())
								 	if (indexCondition>-1){
								 		matchCondition=value.substr(indexCondition,findCondition.length) //根据英文检索条件，获取中文
										}
									}
								}
							 if (matchCondition!=""){ //检索条件不为空，匹配检索条件，作颜色区分
								 var len=value.split(matchCondition).length;
							     var value1="";
							     for (var i=0;i<len;i++){
								 	var otherStr=value.split(matchCondition)[i];
								    if (i==0){
									     if (otherStr!=""){
										    value1=otherStr
										}
									}else{
									    value1=value1+"<font color='red'>"+matchCondition+"</font>"+otherStr;
									}
								 }
						     }else{ //检索条件为空时直接取值
						     	var value1=value;
						     }
						   	   //鼠标悬浮显示备注
								var MKBTNote=rec.MKBTNote
								MKBTNote=MKBTNote.replace(/\ /g, "")
								MKBTNote=MKBTNote.replace(/\>/g, "大于")
								if (MKBTNote!=""){
									value="<span class='hisui-tooltip' title="+MKBTNote+">"+value1+"</span>" 
								}else{
									value="<span class='hisui-tooltip' title="+tooltipText+">"+value1+"</span>" 
								}
			                    return value;     
			                } 
					},
					{field:'comDesc',title:'comDesc',width:80,sortable:true,hidden:true},
					{field:'MKBTCode',title:'诊断代码',width:80,sortable:true,hidden:true},
					{field:'MKBTRowId',title:'MKBTRowId',width:80,sortable:true,hidden:true}
				]],
				onBeforeLoad:function(param){
					if (searchNameCondition!=""){
						findCondition=searchNameCondition
						param = $.extend(param,{desc:searchNameCondition});
						return true;
					}else{
						findCondition=param.q;
						if(param.q!=null && param.q!=undefined && param.q!=''){
							param = $.extend(param,{desc:param.q});
							return true;
						}else{
							if(cbg!=null){
								param = $.extend(param,{desc:""});
								if(document.activeElement.tagName=="INPUT"){//修复没有检索条件时，点击下拉面板分页条，下拉面板消失
									cbg.combogrid('hidePanel');
								}
								return true;	
							}
						}
					}
				},
				/*onClickRow:function (rowIndex, rowData){
					var selected = cbg.combogrid('grid').datagrid('getSelected');  
					if (selected) { 
						ClickDiagCombo(selected.MKBTRowId,selected.MKBTCode,selected.MKBTDesc,selected.comDesc)
					}
				},*/
			   onShowPanel:function(){
			   		cbg = $(this);
			   		//诊断列表弹出时隐藏属性列表
			   		if($("#mypropertylist").is(":hidden")==false){
			   			$("#mypropertylist").hide();
			   		}
			   		cbg.combogrid('textbox').bind('click',function(){ //2018-11-02 重新点击时 默认之前输入的值为选中状态，方便删除
						var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+editIndex+']');
						$(col).find('td[field=SDSDisplayName]').find("input").focus().select();
						searchNameCondition=cbg.combogrid('getText')
     					cbg.combogrid('grid').datagrid('reload');
     					searchNameCondition=""
					 })
					cbg.combogrid("options").keyHandler.up=function(){
						 //取得选中行
		                var selected = $(this).combogrid('grid').datagrid('getSelected');
		                if (selected) {
		                    //取得选中行的rowIndex
		                    var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
		                    //向上移动到第一行为止
		                    if (index > 0) {
		                       $(this).combogrid('grid').datagrid('selectRow', index - 1);
		                    }
		                } else {
		                    var rows = $(this).combogrid('grid').datagrid('getRows');
		                    $(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
		                }
					}
					cbg.combogrid("options").keyHandler.down=function(){
						 //取得选中行
		                var selected = $(this).combogrid('grid').datagrid('getSelected');
		                if (selected) {
		                    //取得选中行的rowIndex
		                    var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
		                    //向下移动到当页最后一行为止
		                    if (index < $(this).combogrid('grid').datagrid('getData').rows.length - 1) {
		                        $(this).combogrid('grid').datagrid('selectRow', index + 1);
		                    }
		                } else {
		                    $(this).combogrid('grid').datagrid('selectRow', 0);
		                }
					}
			   		cbg.combogrid("options").keyHandler.enter=function(){
			   			var selected = $(this).combogrid('grid').datagrid('getSelected');  
	    				if (selected) { 
		               		//ClickDiagCombo(selected.MKBTRowId,selected.MKBTCode,selected.MKBTDesc,selected.comDesc);
	    					ClickDiagCombo(selected.MKBTRowId);
	    				}
					}
			    },
			    /*onHidePanel:function(){
				    setTimeout(function(){
				    	cbg=null;
				    	SelMRCICDRowid=$("#SelMKBRowId").val()
				    	indexTemplate=tkMakeServerCall("web.DHCBL.MKB.SDSStructDiagnos","GetPropertyIdByFlag",SelMRCICDRowid,"DT");;
				    	CreatPropertyDom(target,SelMRCICDRowid,"",indexTemplate);
				    },10)
				   
				},*/
			    onLoadSuccess:function(){
					//var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+editIndex+']');
					//$(col).find('td[field=SDSDisplayName]').find("input").focus();//诊断列表获取焦点
				}
		} 
	}
	
	
	//诊断表达式下拉框诊断点击方法 MKBTRowId-诊断id
	function ClickDiagCombo(MKBTRowId){
	      SelMRCICDRowid=MKBTRowId; //诊断id
	      $("#SelMKBRowId").val(SelMRCICDRowid);
	      $("#DiagForm").empty();
	      cbg.combogrid("hidePanel");
	}
	
	//添加右键股则管理菜单
	var rightMenuInfos=tkMakeServerCall('web.DHCBL.MKB.MKBKLMappingDetail','CreateRightMenu',termBase);
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
				iconCls:"icon-set-paper",
				id:rightMenu.MKBKMBRowId
			});*/
			menuStr=menuStr+'<div id='+rightMenu.MKBKMBRowId+' name="规则管理" iconCls="icon-set-paper" data-options="">'+rightMenu.MKBKMBDesc+'</div>'			
		}
		menuStr='<div iconCls="icon-batch-cfg"><span>规则管理</span><div style="width:200px;">'+menuStr+'</div></div>'
	}	

	//datagrid列
	var columns =[[  
					{field:'MKBTPDRowId',title:'RowId',width:80,sortable:true,hidden:true},
					{field:'MKBTPDCode',title:'代码',width:80,sortable:false,hidden:true},
					{field:'MKBTPDDesc',title:propertyName,width:150,sortable:false,editor:'validatebox'
					,formatter:function(value,row,index){  
						//鼠标悬浮显示备注信息
						return '<span class="mytooltip" title="'+row.MKBTPDDesc+'">'+value+'</span>'
					}},					
					{field:'MKBTPDRemark',title:'备注',width:150,sortable:false,editor:{type:'textarea'},
					formatter:function(value,row,index){  
						//鼠标悬浮显示备注信息
						return '<span class="mytooltip" title="'+row.MKBTPDRemark+'">'+value+'</span>'
					}},	
					{field:'MKBTPDPYCode',title:'检索码',width:150,sortable:false,editor:'validatebox'},
					{field:'MKBTPDSequence',title:'顺序',width:150,sortable:true,hidden:true,
						sorter:function (a,b){  
							if(a.length > b.length) return 1;
								else if(a.length < b.length) return -1;
								else if(a > b) return 1;
								else return -1;
						}
					}
				]];
	
	 //如果有扩展属性，则自动生成列
	if (extendChild!="")  
	{	
		var colsField = extendChild.split("[N]"); 
		var colsHead = extendTitle.split("[N]"); 
		var typeStr = extendType.split("[N]"); 
		var configStr = extendConfig.split("[N]"); 
		//alert(configStr)
		for (var i = 0; i <colsField.length; i++) {
			var fieldid=colsField[i];
			var labelName=colsHead[i];  //标题
			var comId='Extend'+colsField[i];   //控件id				
			var type=typeStr[i]   //类型
			var configInfos=configStr[i]  //配置项
			
			if (labelName=="展示名")
			{
				showNameChild=comId
			}

			//添加列 方法1
			/*var record=[{
						 field:'Extend'+colsField[i],
						 title:colsHead[i],
						 width:150,
						 sortable:true
					}]
			columns[0].push(record[0])*/

			//添加列 方法2
			var column={};  
			column["title"]=labelName;  
			column["field"]=comId;  
			column["width"]=150;  
			column["sortable"]=false; 
			if (type=="TX") //文本框
			{
				column["editor"]='validatebox'
			}
			else if (type=="TA")  //多行文本框
			{
				column["editor"]={type:'textarea'}
				column["formatter"]=function(value,row,index){  
					//鼠标悬浮显示备注信息
					return '<span class="mytooltip" title="'+value+'">'+value+'</span>'
				}
				
				//多行文本框
				textareInfoArr[fieldid]=""
				
			}
			else if(type=="S")  //引用  注意：要换成MKBTerm，同时还要判断是列表下拉框还是树形下拉框
			{			
				if (configInfos=="") return 
				sourseInfoArr[fieldid]=""
				//先加一列
				var columnF={};
				columnF["title"]=labelName+"ID";  
				columnF["field"]=comId+"F";  
				columnF["editor"]='validatebox';
				columnF["width"]=150;  
				columnF["sortable"]=false;
				columnF["hidden"]=true;
				
				columns[0].push(columnF)
				
				var baseInfo = configInfos.split("&%"); 
				var baseid=baseInfo[0]   //术语库注册id
				var baseType=baseInfo[1]   //术语库类型
				if (baseType=="T")  //下拉树			
				{
					urlArr["T"+fieldid]="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetJsonDataForTermCmb&base="+baseid
					column["editor"]={
						type:'combotree',
						options:{
							//url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmb&base="+baseid,
							comboFieldId:fieldid, //child
							onBeforeExpand:function(node){
								$(this).tree('expandFirstChildNodes',node)
					        },
							onShowPanel:function(){	
								var opts = $(this).combotree('options')
				         		if (opts)
				         		{
				         			$(this).combotree('reload',urlArr["T"+opts.comboFieldId]);
				         		}

				         	},
							onHidePanel:function(){
				         		var opts = $(this).combotree('options')
				         		if (opts)
				         		{
					         		var target=$(this)
									setTimeout(function(){
										//var val=target.next().find('.combo-text').val();
										var val=target.combobox('getText');
						        		var ed = $('#mygrid').datagrid('getEditor', {index:editIndex,field:"Extend"+opts.comboFieldId+"F"});
										$(ed.target).val(val)
									},100)
				         		}
				         											
								if($(this).combo('getText')==""){
									$(this).combo('setValue',"")
								}
							}							
						}
					}
					
				}
				else   //下拉框
				{
					urlArr[fieldid]=$URL+"?ClassName=web.DHCBL.MKB.MKBTermProDetail&QueryName=GetTermCmb&ResultSetType=array&base="+baseid
					column["editor"]={
						type:'combobox',
						options:{
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
				         	},
				         	onHidePanel:function(){	
				         		var opts = $(this).combobox('options')
				         		if (opts)
				         		{
				         			var val=$(this).combobox('getText');
						        	var ed = $('#mygrid').datagrid('getEditor', {index:editIndex,field:"Extend"+opts.comboFieldId+"F"});
									$(ed.target).val(val)
				         		}
							}
						}
					}
				}
			
			}
			else if (type=="C")  //下拉框
			{	
		
				var configs = configInfos.split("&%"); 
				var storeData=new Array()
				for (var j = 0; j <configs.length; j++) {
					var data={};  
					data["value"]=configs[j];  
					data["text"]=configs[j];  
					storeData.push(data)	
				}
				column["editor"]={
					type:'combobox',
					options:{
						valueField:'value',
						textField:'text',
						data:storeData						
					}
				}	
				
			}
			else if (type=="R")  //单选框
			{
				var configs = configInfos.split("&%"); 
				var storeData=new Array()
				for (var j = 0; j <configs.length; j++) {
					var data={};  
					data["value"]=configs[j];  
					data["text"]=configs[j];  
					storeData.push(data)	
				}
				column["editor"]={
					type:'comboboxradio',					
					options:{
						valueField:'value',
						textField:'text',
						data:storeData,
						comId:comId							
					}
				}	
				
			}
			else if (type=="CB")
			{
				var configs = configInfos.split("&%"); 
				var storeData=new Array()
				for (var j = 0; j <configs.length; j++) {
					var data={};  
					data["value"]=configs[j];  
					data["text"]=configs[j];  
					storeData.push(data)	
				}
				column["editor"]={
					type:'combobox',
					options:{
						rowStyle:'checkbox', //显示成勾选行形式
						valueField:'value',
						textField:'text',
						data:storeData,
						comId:comId,
						multiple:true					
					}
				}					
			}
			else if(type=="SD")  //知识表达式
			{
				if (configInfos=="") return 
				//column["editor"]='validatebox'
				column["editor"]=DisplayNameEditor //表达式控件所需代码
				expressInfoArr[fieldid]=configInfos
				
				//先加一列
				var column1={};  
				column1["title"]=labelName+"id串";  
				column1["field"]=comId+"F";  
				column1["width"]=150;  
				column1["sortable"]=false;
				column1["editor"]='validatebox'
				column1["hidden"]=true;
				columns[0].push(column1)
				
				
			}
			else if (type=="D")  //日期
			{
				column["editor"]={
					type:'datebox',
					options:{
				  		onShowPanel:function(){
				  			$(this).datebox('panel').click(stopPropagation)
				  		}			
					}
				}	
				
			}

			columns[0].push(column)
		
		}
	}
	///列表datagrid
	var mygrid = $HUI.datagrid("#mygrid",{
		url:QUERY_ACTION_URL+"&property="+property+"&rowid="+detailId,
		columns:columns,
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		idField:'MKBTPDRowId', 
		toolbar:'#mytbar',
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		sortName : 'MKBTPDSequence',
		sortOrder : 'asc', 
		ClassTableName:HISUI_ClassTableName,
		SQLTableName:HISUI_SQLTableName, 
		onDblClickRow:function(rowIndex,rowData){
			//$('.mytooltip').tooltip('hide');
			//双击事件
			DblClickFun(rowIndex,rowData)
			//改变上移下移按钮状态
			changeUpDownStatus(rowIndex);
		},
		onClickRow:function(rowIndex,rowData){
			//$('#knoExe').css('display','none'); 
			$("#mypropertylist").hide();
			$('mygrid').datagrid('selectRow', rowIndex);
			ClickFun();
			//改变上移下移按钮状态
			changeUpDownStatus(rowIndex);
			
			//保存历史和频次记录
			RefreshSearchData(HISUI_ClassTableName,rowData.MKBTPDRowId,"A",rowData.MKBTPDDesc)
		},
		onLoadSuccess:function(data){
			/*$('.mytooltip').tooltip({
				trackMouse:true,
				onShow:function(e){
					$(this).tooltip('tip').css({
						width:250 ,top:e.pageY+20,left:e.pageX-(250/2)
					});
				}

			});*/
			/*$('.mytooltip').each(function(){
		    	var _yy=$(this).offset().top;
		    	if($(window).height()-_yy<100){
			    	$(this).tooltip({
				    	position:'top',
				    	trackMouse:true,
				    	onShow:function(e){
							$(this).tooltip('tip').css({
								width:500 ,left:e.pageX-(500/2)
							});
							if($(this).tooltip('tip').height()>400){
								$(this).tooltip('tip').css({
									width:700 ,top:e.pageY+40,left:e.pageX-(700/2)
								});
							}
						}
				    })
			    }
			    else{
					$(this).tooltip({
				    	trackMouse:true,
				    	onShow:function(e){
							$(this).tooltip('tip').css({
								width:500 ,left:e.pageX-(500/2)
							});
							if($(this).tooltip('tip').height()>400){
								$(this).tooltip('tip').css({
									width:700 ,top:e.pageY-40,left:e.pageX-(700/2)
								});
							}
						}
				    })
				}
		    })*/
        	$(this).datagrid('columnMoving');
        	//相关知识点定位到具体的属性内容
        	if (detailId!="")
        	{
        		//var index=$(this).datagrid('getRowIndex',detailId);
        		$(this).datagrid('selectRow',0);
        		//$(this).prev().find('div.datagrid-body').prop('scrollTop',index);
        	}
        	var firstLoad = $(this).attr("firstLoad");
        	
            
            	if ((detaildesc!="")&&(detailstruct!=""))	//新增常用诊断表达式
	        	{
	        		rowsvalue=undefined
	        		editIndex=undefined
	        		//$(this).attr("firstLoad","true");
	        		var structvalue=detailstruct.split("#")[0]
	        		var structdesc=detailstruct.split("#")[1]
	        		AddData();
	        		var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+editIndex+']')[1];
	        		
			    	var comId=""
					var baseId=""
			        for(fieldid in expressInfoArr) {
						//如果表达式配置项=当前的术语库
						if ((expressInfoArr[fieldid]==termBase))
						{	
							
							comId="Extend"+fieldid
							baseId=expressInfoArr[fieldid]	
						}
					}

					var target=$(col).find('td[field='+comId+'] input')
			    	target.click()			
				
	        	}
            
	            
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
        	{
        		SecondLoad=SecondLoad+1
        	}

	        	
		},
		onRowContextMenu: function(e, rowIndex, rowData){   //右键菜单
				var $clicked=$(e.target);
				copytext =$clicked.text()||$clicked.val()   //普通复制功能
				e.preventDefault();  //阻止浏览器捕获右键事件
				var record=$(this).datagrid("selectRow", rowIndex); //根据索引选中该行  

				//处理右键里的上移、下移、移动首行的隐藏与显示	
				var upDisable=false,downDisable=false
				if (rowIndex==0){
					upDisable=true
				}
				var rows = $('#mygrid').datagrid('getRows');
				if ((rowIndex+1)==rows.length){
					downDisable=true
				}
				/*if(rowIndex==0){
					$('#shiftup').attr("disabled", "disabled").css({ "cursor": "default", "opacity": "0.4" });
					$('#shiftfirst').attr("disabled", "disabled").css({ "cursor": "default", "opacity": "0.4" });
				}
				else
				{
					$('#shiftup').removeAttr('disabled').css({ "cursor": "pointer", "opacity": "1" });
					$('#shiftfirst').removeAttr('disabled').css({ "cursor": "pointer", "opacity": "1" });
				}
				var rows = $('#mygrid').datagrid('getRows');
				if ((rowIndex+1)==rows.length){
					$('#shiftdown').attr("disabled", "disabled").css({ "cursor": "default", "opacity": "0.4" });
				}
				else
				{
					$('#shiftdown').removeAttr('disabled').css({ "cursor": "pointer", "opacity": "1" });
				}


				$('#myMenu').menu({
				    onClick:function(item){
				    	var itemid=item.id
						if ((item.name=="规则管理")&(itemid!="")&(itemid!=null)&(itemid!=undefined)){	
							var detailIdStr=termRowId+"-"+property+":"+rowData.MKBTPDRowId
							var newOpenUrl="../csp/dhc.bdp.mkb.mkbklmappingdetail.csp?mappingBase="+itemid+"&termBase="+termBase+"&detailIdStr="+detailIdStr
							window.open(newOpenUrl, 'newwindow', 'height=400, width=880, top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no')				
						}
				    }
				});
				
				$('#myMenu').menu('show', {    
					  left:e.pageX,  
					  top:e.pageY
				})*/
				
				//添加右键股则管理菜单和文献预览菜单
	            var docMenuStr=""
	            var detailIdStr=termRowId+"-"+property+":"+rowData.MKBTPDRowId
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
				
	            var mygridmm = $('<div style="width:120px;"></div>').appendTo('body');
	            mygridmm.html(
	           // $(
	                '<div id="del_menu" onclick="DelData()" iconCls="icon-cancel" data-options="">删除</div>' +
					'<div id="copy_menu" onclick="CopyText()" iconCls="icon-copy" data-options="">复制单元格</div>' +
					'<div class="menu-sep"></div>' +
					'<div iconCls="icon-changeposition">' +
		            '<span>位置移动</span>'+
		          	 	'<div style="width:80px;">'+
		                '<div onclick="OrderFunLib(1)" iconCls="icon-shiftup" id="shiftup" data-options="disabled:'+upDisable+'">上移</div>'+
		                '<div onclick="OrderFunLib(2)" iconCls="icon-shiftdown" id="shiftdown" data-options="disabled:'+downDisable+'">下移</div>'+
		                '<div onclick="OrderFunLib(3)" iconCls="icon-shiftfirst" id="shiftfirst" data-options="disabled:'+upDisable+'">移动到首行</div>'+
		            	'</div>'+
		        	'</div>'+
		        	'<div onclick="SeeVersion()" iconCls="icon-apply-check" data-options="">查看版本</div>' +
	       			'<div onclick="SeeChangeLog()" iconCls="icon-apply-check" data-options="">查看日志</div>'+menuStr+docMenuStr
	            //).appendTo(mygridmm).click(stopPropagation);  //右键菜单里 在IE8下点击右键菜单的按钮 ，没有执行点击事件，原因：append的onclick不会触发，用html的可以触发。
		        ).click(stopPropagation);
	            //mygridmm.menu()
	           mygridmm.menu({
				    onClick:function(item){
				    	var itemid=item.id
						if ((item.name=="规则管理")&(itemid!="")&(itemid!=null)&(itemid!=undefined)){	
							var detailIdStr=termRowId+"-"+property+":"+rowData.MKBTPDRowId
							var newOpenUrl="../csp/dhc.bdp.mkb.mkbklmappingdetail.csp?mappingBase="+itemid+"&termBase="+termBase+"&detailIdStr="+detailIdStr
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
				
				
			}
	});
	
	//用户习惯
	ShowUserHabit('mygrid');
	
	///查询按钮
	/*$('#TextDesc').searchbox({
		searcher:function(value,name){
			//alert(value + "," + name)
			SearchFunLib();
		}
	});*/
	
	 //类百度查询框
	$('#TextDesc').searchcombobox({ 
		url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+HISUI_ClassTableName,
		onSelect:function () 
		{	
			$(this).combobox('textbox').focus();
			SearchFunLib()  
	        
        }
	});
	
	$('#TextDesc').combobox('textbox').bind('keyup',function(e){ 
		if (e.keyCode==13){ 
			SearchFunLib() 
		}
    }); 

    $("#btnSearch").click(function (e) { 
		SearchFunLib();
	})   

	
	///重置按钮
	$("#btnRefresh").click(function (e) { 
		ClearFunLib();
	 }) 
 
	///添加按钮
	$("#add_btn").click(function (e) { 
		//$('#knoExe').css('display','none');
		AddData();
	}) 
	
	///保存按钮
	$("#save_btn").click(function (e) { 
		SaveFunLib();
	}) 

	//右键复制
	 $("#copy_menu").click(function(e){
		CopyText()
	})
	
	//右键删除
	 $("#del_menu").click(function(e){
		DelData()
	})
	
	///删除按钮
	$("#del_btn").click(function (e) { 
		DelData();
	})  
	
	//删除全部按钮
	$("#delAllbtn").click(function (e) { 
		DelAllData();
	}) 
	
	///上移
	$("#btnUp").click(function (e) { 
		OrderFunLib(1);
	 })  
	///下移
	$("#btnDown").click(function (e) { 
		OrderFunLib(2);
	 }) 
	///置顶
	$("#btnFirst").click(function (e) { 
		OrderFunLib(3);
	 }) 

	//放大按钮
	$("#btnSpread").click(function (e) {
		var winTitle=tkMakeServerCall('web.DHCBL.MKB.MKBTermProDetail','GetProAndTermDesc',property);
		var newOpenUrl="dhc.bdp.mkb.mkbtermprodetaillist.csp?property="+property
		if ('undefined'!==typeof websys_getMWToken){
			newOpenUrl += "&MWToken="+websys_getMWToken()
		}
		//previewWin =window.open(newOpenUrl, 'newwindow', 'height=500, width=880, top=200, left=200, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no')			
        var $parent = self.parent.$;
		var previewWin=$parent("#myWinGuideImage").window({
            width:winwidth,
            height: winheight,
            modal:false,
            iconCls:'icon-w-paper',
            title:winTitle+"属性内容",
            content:'<iframe id="timeline" frameborder="0" src="'+newOpenUrl+'" width="100%" height="99%" scrolling="no"></iframe>',
            onClose:function(){
            	ClearFunLib();
            }
        });
        previewWin.show();

	}) 
	
	$('.datagrid-pager').find('a').each(function(){
		$(this).click(function(){
			//$('#knoExe').css('display','none'); 
			$("#mypropertylist").hide();
			editIndex = undefined;
			rowsvalue=undefined;
			oldrowsvalue=undefined;
			preeditIndex="";
		})
	})
	
	//用于单击非grid行保存可编辑行
	/*$(document).bind('click',function(){ 
	    ClickFun()
	}); */
	
	//加载表达式、多行文本框等可编辑表格控件
	function AppendDom(){

		if (editIndex!=undefined)
		{
			var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+editIndex+']')[1];
	        $(col).find('table').each(function(){
				var target=$(this).find('input:first')
				if(target.css('display')=='none'){
					target.next().find('input:first').click(function(){
						//表达式控件所需代码
						//$('#knoExe').css('display','none');
						$("#mypropertylist").hide();
					})
				}
				else{
					target.click(function(){
						//表达式控件所需代码
						//$('#knoExe').css('display','none'); 
						$("#mypropertylist").hide();
					})
				}
			})	  
			//加载表达式控件
			for(fieldid in expressInfoArr) {
				var comId="Extend"+fieldid
				var baseId=expressInfoArr[fieldid]
				CreateExpDom(col,comId,baseId)
			}
			
			//备注多行文本框
			CreateTADom(col,"MKBTPDRemark")	
			//加载多行文本框控件
			for(fieldid in textareInfoArr) {
				var comId="Extend"+fieldid
				CreateTADom(col,comId)			
			}	
			
			//展示名和拼音码赋值
			var descTarget=$(col).find('td[field=MKBTPDDesc] input')
			if (mygrid.getRows()[editIndex].MKBTPDRowId==undefined) 
			{
				
				descTarget.keyup(function(){	
					var desc=descTarget.val()  //中心词列的值
					if (showNameChild!="")  //展示名赋值
					{				
						var showNameCol=$("#mygrid").datagrid("getEditor",{index:editIndex,field:showNameChild});	
						$(showNameCol.target).val(desc)
					}		
					//检索码赋值
					var PYCode=Pinyin.GetJPU(desc)
					var PYCodeCol=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"MKBTPDPYCode"});							
					$(PYCodeCol.target).val(PYCode)					
				})
			}
			descTarget.click(function(){
				var desc=descTarget.val()  //中心词列的值
				if (showNameChild!="")  //展示名赋值
				{				
					var showNameCol=$("#mygrid").datagrid("getEditor",{index:editIndex,field:showNameChild});	
					if ((mygrid.getRows()[editIndex].MKBTPDRowId==undefined)||(showNameCol.target.val()==""))
					{
						$(showNameCol.target).val(desc)
					}
				}
			
				//检索码赋值
				var PYCode=Pinyin.GetJPU(desc)
				var PYCodeCol=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"MKBTPDPYCode"});	
				if ((mygrid.getRows()[editIndex].MKBTPDRowId==undefined)||(PYCodeCol.target.val()==""))
				{
					$(PYCodeCol.target).val(PYCode)
				}
				
			})		
			
		}
	} 
	
	//判断是否是数字
	function isNumber(value) {
	    var patrn = /^[0-9]*$/;
	    if (patrn.exec(value) == null || value == "") {
	        return false
	    } else {
	        return true
	    }
	}
	
	//修改完后给这一行赋值
	function UpdataRow(row,Index,TAType){

		//引用控件
		for(fieldid in sourseInfoArr) {
			var comId="Extend"+fieldid
			var comIdF="Extend"+fieldid+"F"
		    var temp;
		    if (isNumber(row[comIdF])||isNumber(row[comId]))
		    {
				temp=row[comId]
				row[comId]=row[comIdF]
				row[comIdF]=temp
		    }
		    else
		    {
		    	row[comId]=""
		    	row[comIdF]=""
		    }
		}
		
		//处理换行符
		if(TAType=="1")   //双击的时候</br>转换为\n
		{
			//多行文本框
			for(fieldid in textareInfoArr) {
				var comId="Extend"+fieldid
				row[comId]=row[comId].replace(/<br\/>/g,"\n");   	
			}	
			//备注
			row.MKBTPDRemark=row.MKBTPDRemark.replace(/<br\/>/g,"\n"); 
		}
		else   //保存成功的时候\n转换为</br>
		{
				//多行文本框
			for(fieldid in textareInfoArr) {
				var comId="Extend"+fieldid
				row[comId]=row[comId].replace(/\n/g,"<br\/>");   	
			}	
			//备注
			row.MKBTPDRemark=row.MKBTPDRemark.replace(/\n/g,"<br\/>"); 		
		}
		//console.log(row)
		
		$('#mygrid').datagrid('updateRow',{
			index: Index,
			row:row
		})
		/*$('.mytooltip').tooltip({
			trackMouse:true,
			onShow:function(e){
				$(this).tooltip('tip').css({
					width:250 ,top:e.pageY+20,left:e.pageX-(250/2)
				});
			}

		});*/
		/*$('.mytooltip').each(function(){
		    	var _yy=$(this).offset().top;
		    	if($(window).height()-_yy<100){
			    	$(this).tooltip({
				    	position:'top',
				    	trackMouse:true,
				    	onShow:function(e){
							$(this).tooltip('tip').css({
								width:500 ,left:e.pageX-(500/2)
							});
							if($(this).tooltip('tip').height()>400){
								$(this).tooltip('tip').css({
									width:700 ,top:e.pageY+40,left:e.pageX-(700/2)
								});
							}
						}
				    })
			    }
			    else{
					$(this).tooltip({
				    	trackMouse:true,
				    	onShow:function(e){
							$(this).tooltip('tip').css({
								width:500 ,left:e.pageX-(500/2)
							});
							if($(this).tooltip('tip').height()>400){
								$(this).tooltip('tip').css({
									width:700 ,top:e.pageY-40,left:e.pageX-(700/2)
								});
							}
						}
				    })
				}
		    })*/
	}
	
	//是否有正在编辑的行true/false
	function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#mygrid').datagrid('validateRow', editIndex)){
			$('#mygrid').datagrid('endEdit', editIndex);
			rowsvalue=mygrid.getRows()[editIndex];
			//editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}  
	
	
	//grid单击事件
	function ClickFun(saveType){   //单击执行保存可编辑行
		
		if (endEditing()){

			console.log(rowsvalue)
			console.log(oldrowsvalue)
			if(rowsvalue!= undefined){
				if((rowsvalue.MKBTPDDesc!="")){
					var differentflag="";
					if(oldrowsvalue!= undefined){
						var oldrowsvaluearr=JSON.parse(oldrowsvalue)
						for(var params in rowsvalue){
							if(oldrowsvaluearr[params]==undefined){oldrowsvaluearr[params]=""}
							if(rowsvalue[params]==undefined){rowsvalue[params]=""}
							if(oldrowsvaluearr[params]!=rowsvalue[params]){
								differentflag=1
							}
						}
					}
					else{
						differentflag=1
					}
					if(differentflag==1){
						preeditIndex=editIndex
						SaveData(rowsvalue,saveType);
					}
					else{
						UpdataRow(rowsvalue,editIndex)
						editIndex=undefined
						rowsvalue=undefined
					}
				}
				else{
					$.messager.alert('错误提示',propertyName+'不能为空!',"error");
					$('#mygrid').datagrid('selectRow', editIndex)
						.datagrid('beginEdit', editIndex);
					AppendDom()
					return
				}
			}

		}
	}

	
	//grid双击事件
	function DblClickFun (index,row){   //双击激活可编辑   （可精简）		
		if(index==editIndex){
			return
		}
		if((row!=undefined)&&(row.MKBTPDRowId!=undefined)){
			UpdataRow(row,index,"1")
		}
		preeditIndex=editIndex
		if (editIndex != index){
			if (endEditing()){
				$('#mygrid').datagrid('selectRow', index)
						.datagrid('beginEdit', index);
				editIndex = index;
			} else {
				$('#mygrid').datagrid('selectRow', editIndex);
			}
		}
		oldrowsvalue=JSON.stringify(row);   //用于和rowvalue比较 以判断是否行值发生改变
		AppendDom()
		
		// 引用类型的下拉框双击时只加载一条数据
		for(urlChild in urlArr) {
			var TFlag=""
			var url=urlArr[urlChild]
			if (urlChild.indexOf("T")>-1)
			{
				urlChild=urlChild.split("T")[1]			
				TFlag="Y"
			}
			var ed =  $("#mygrid").datagrid("getEditor",{index:index,field:"Extend"+urlChild});	
			var comId="Extend"+urlChild;
			var idF =row[comId]	
			if ((idF!="")&(idF!=undefined)){
				url=url+"&rowid="+idF
				if (TFlag=="Y")
				{
					$(ed.target).combotree('reload',url);
				}
				else
				{
					$(ed.target).combobox('reload',url);
				}
			}	
		}
		
	}
	
	//点击新增按钮后新增一行
	function AddData(){
		preeditIndex=editIndex;
		ClickFun('AddData')
		if (endEditing()){
			$('#mygrid').datagrid('insertRow',{index:0,row:{}});
			editIndex = 0;//$('#mygrid').datagrid('getRows').length-1;
			$('#mygrid').datagrid('selectRow', editIndex)
					.datagrid('beginEdit', editIndex);
		}
		$('.eaitor-label span').each(function(){	                    
            $(this).unbind('click').click(function(){
                if($(this).prev()._propAttr('checked')){
                    $(target).combobox('unselect',$(this).attr('value'));

                }
                else{
	                $(target).combobox('select',$(this).attr('value'));
	            }
            })
        });
        if (detaildesc!="")
        {
        	var desced=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"MKBTPDDesc"});	
        	$(desced.target).val(detaildesc)
        	var PYCode=Pinyin.GetJPU(detaildesc)
			var PYCodeCol=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"MKBTPDPYCode"});							
			$(PYCodeCol.target).val(PYCode)	
        }
        
         //新增时为表达式单元格赋值
        for(fieldid in expressInfoArr) {
			//如果表达式配置项=当前的术语库
			if ((expressInfoArr[fieldid]==termBase))
			{	
				var ed=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"Extend"+fieldid});	
				var edF=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"Extend"+fieldid+"F"});	
				//$(ed.target).val(detailDescStr)	
				if ((detaildesc!="")&&(detailstruct!=""))	//新增常用诊断表达式
				{
					var detail=tkMakeServerCall('web.DHCBL.MKB.MKBKLMappingDetail','GetExpDesc',detailstruct)
					$(ed.target).combogrid('setValue', detail)
					$(edF.target).val(detailstruct)
				}
				else
				{
					$(ed.target).combogrid('setValue', termCom)
					$(edF.target).val(termRowId)
				}
				
				break;
			}
		}
		
        AppendDom()
		
	}	

	//点击保存按钮后调用此方法
	function SaveFunLib(){
		var ed = $('#mygrid').datagrid('getEditors',editIndex); 
		if(ed!=""){
			preeditIndex=editIndex;
			if (endEditing()){
				var record=mygrid.getSelected();
				//console.log(record)	  
				//return
				SaveData(record);
			}
		}
		else{
			$.messager.alert('警告','请双击选择一条数据！','warning')
		}
	}
	
	///保存方法
	function SaveData(record,saveType){
		if((rowsvalue.MKBTPDDesc=="")){
			$.messager.alert('错误提示',propertyName+'不能为空!',"error");
			$('#mygrid').datagrid('selectRow', editIndex)
				.datagrid('beginEdit', editIndex);
			AppendDom()
			return		
		}
		
		//获取所有扩展属性的值
		var extendValue=""
		if (extendChild!="")   //如果有扩展属性
		{
			var colsField = extendChild.split("[N]"); 
			var typeStr = extendType.split("[N]"); 
			var configStr = extendConfig.split("[N]"); 

			for (var i = 0; i <colsField.length; i++) 
			{
				var childid="Extend"+colsField[i]
				var type=typeStr[i]
				var child=colsField[i]
				var extProValue=record[childid]	  //获取可编辑列表的值
				
				if(type=="SD")  //表达式
				{
					if (extProValue!="")
					{
						extProValue=record[childid+"F"]	  //获取可编辑列表的值
					}
				}
				
				if ((extProValue=="undefined")||(extProValue==null)){extProValue=""}
				
				if(type=="CB")  //复选框,用","连接替换成用"&%"
				{
					if (extProValue!="")
					{
						extProValue=extProValue.replace(/\,/g,"&%")
					}
				}
							
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
		
		//把扩展属性加到record里
		var extendPro={
			"MKBTPDProDR":property,
			"MKBTPDExtend":extendValue
		}
		for(var key in extendPro){
			record[key] = extendPro[key];
		}

		//console.log(record);
		//执行保存
		$.ajax({
			type: 'post',
			url: SAVE_ACTION_URL,
			data: record,
			success: function (data) { //返回json结果			
				var data=eval('('+data+')');
				if(data.success=='true'){
				  /*$.messager.show({
					title:'提示信息',
					msg:'保存成功',
					showType:'show',
					timeout:1000,
					style:{
					  right:'',
					  bottom:''
					}
				  })*/
				  detaildesc=""
				  detailstruct=""

				  $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				  if(saveType=='AddData'){
				      preeditIndex=preeditIndex+1;
				  }
				  //alert(saveType+"&"+preeditIndex)
				  record.MKBTPDRowId=data.id
				  UpdataRow(record,preeditIndex);
				  if(saveType!='AddData'){
						editIndex=undefined
						rowsvalue=undefined
					}
				  //parent.UpdateMKBTPDDescCell(property,"L")
				}
				else{
					var errorMsg="保存失败！";
					if(data.errorinfo)
					{
						errorMsg=errorMsg+'</br>错误信息:'+data.errorinfo
						if (data.errorinfo.indexOf("存在")!=-1)
						{
							detaildesc=""
				  			detailstruct=""
							var sameid=data.RowID
							$("#sameData").show();
							var sameData = $HUI.dialog("#sameData",{
							    resizable:true,
								modal:true,
								zIndex: 110100,  
								buttonAlign : 'center',
							    title: '数据重复',                                                                      
							    content:'<div style="margin:10px"><div class="messager-icon messager-question"></div><div>存在相同的常用诊断表达式</div></div>',
							    buttons:[{
						            text:'修改',
						            handler:function()
						            { 
						            	$('#sameData').dialog('close')
						            	$('#mygrid').datagrid('deleteRow', editIndex);//将正在编辑的行数据删除
						            	editIndex=undefined
						            	rowsvalue=undefined
						            	var rowIndex=$('#mygrid').datagrid("getRowIndex",sameid)
								        if (rowIndex>=0)
								        {					        									        	
								        	var value=$('#mygrid').datagrid("getRows")[rowIndex];
									        editIndex=undefined
									        DblClickFun(rowIndex,value)
								        }
								        else		//数据不在本页
								        {
								        	var propertyid=record.MKBTPDProDR
								        	var value=tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail", "NewOpenData", sameid,propertyid);
								        	var value=eval('('+value+')');
								        	$('#mygrid').datagrid('insertRow',{
												index: 0,
												row: value
											});
											
									        DblClickFun(0,value)
								        	//d ##class(web.DHCBL.MKB.MKBTermProDetail).NewOpenData(id,property)
								        }


						    		}
					        	},{
						            text:'放弃',
						            handler:function()
						            { 
						            	//detaildesc=""
				  						//detailstruct=""
						            	$('#sameData').dialog('close')
						            	$('#mygrid').datagrid('deleteRow', editIndex);	//将正在编辑的行数据删除
						    			editIndex=undefined
						            	rowsvalue=undefined
						    			
						    		}
					        	}]
							})

						}
						else
						{
							$.messager.alert('错误提示',errorMsg,'error',function(){
								UpdataRow(record,preeditIndex)
					       		editIndex=undefined
					       		DblClickFun (preeditIndex,record);
					        })
						}
					}

						
			   }
			}
		});
		
	}
	
	 ///查询方法
	SearchFunLib=function()
	{
		//var desc=$.trim($('#TextDesc').searchbox('getValue'));
		//相关知识点定位到具体的属性内容，查询或重置后查询所有
		if(detailId!="")
		{
			$('#mygrid').datagrid('options').url = QUERY_ACTION_URL+"&property="+property; // 重新赋值url 属性
			detailId=""
		}
		var desc=$("#TextDesc").combobox('getText')
		$('#mygrid').datagrid('load',  {		
			'desc':desc,	
			'property':property
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	///重置方法
	ClearFunLib=function()
	{	
		//相关知识点定位到具体的属性内容，查询或重置后查询所有
		if(detailId!="")
		{
			$('#mygrid').datagrid('options').url = QUERY_ACTION_URL+"&property="+property; // 重新赋值url 属性
			detailId=""
		}
		editIndex = undefined;  //正在编辑的行index
		rowsvalue=undefined;   //正在编辑的行数据

		//$("#TextDesc").searchbox('setValue', '');
		$("#TextDesc").combobox('setValue', '');
		$('#mygrid').datagrid('load',  { 
			'property':property
		});
		$('#mygrid').datagrid('unselectAll');
		//上移下移按钮改为可用
		$('#btnUp').linkbutton('enable');
		$('#btnDown').linkbutton('enable');
		$('#btnFirst').linkbutton('enable');
		detaildesc=""
		detailstruct=""
	}
	
	// 所选术语的引用数据
	ReferedList=function(id){
	    if(id=="")
	    {
		    $.messager.alert('错误提示','请先选择一条记录!',"error");
		    return;
		}
		var MKBReferFlag="D"
		var url='dhc.bdp.mkb.mkbreferedlist.csp?MKBReferID='+id+'&MKBReferFlag='+MKBReferFlag
		if ('undefined'!==typeof websys_getMWToken){
			url += "&MWToken="+websys_getMWToken()
		}
		$("#myWinReferedList").show();  
		var myWinReferedList = $HUI.window("#myWinReferedList",{
			resizable:true,
			collapsible:false,
			minimizable:false,   
			title:'引用信息',
			modal:true,
			content:'<iframe id="myiframeReferedList" name="myiframeReferedList" frameborder="0" src="'+url+'" width="99%" height="98%" scrolling="no"></iframe>'
		});	
	}
	
	///删除
	DelData=function()
	{        
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		if((record.MKBTPDRowId==undefined)||(record.MKBTPDRowId=="")){
			mygrid.deleteRow(editIndex)
			editIndex = undefined;
			return;
		}
		
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){	
				$.ajax({
					url:DELETE_ACTION_URL,  
					data:{
						"id":record.MKBTPDRowId      ///rowid
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
									$('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
									$('#mygrid').datagrid('unselectAll');  // 清空列表选中数据
									editIndex = undefined;
									rowsvalue=undefined;
									//parent.UpdateMKBTPDDescCell(property,"L")
							  } 
							  else { 
									var errorMsg =""
									if (data.info) {																
										if (data.info.indexOf("引用")!=-1)
										{
											errorMsg =data.info+ '<br/><font style="color:red;">确定要删除该数据及所有引用数据吗？</font><a href="javascript:void(0)" onclick="ReferedList('+record.MKBTPDRowId+')">查看所有引用</a>'
											$.messager.confirm('提示', errorMsg, function(r){
												if (r){
													DelReferData(record.MKBTPDRowId)
												}
											});
										}
										else
										{
											errorMsg ='删除失败！<br/>错误信息:' + data.info	
											$.messager.alert('操作提示',errorMsg,"error");
										}
									}
					
							}			
					}  
				})
			}
		});
	}
	
	///删除引用数据
	DelReferData=function(referID)
	{        
		if (referID=="")
		{
			return
		}

		var data=tkMakeServerCall('web.DHCBL.MKB.MKBTermProDetail','DeleteDataAndRefer',referID);
		  var data=eval('('+data+')'); 
		  if (data.success == 'true') {
		  	    $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
				$('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
				$('#mygrid').datagrid('unselectAll');  // 清空列表选中数据
				editIndex = undefined;
				rowsvalue=undefined;
		  } 
		  else { 
				var errorMsg ="删除失败！"
				if (data.info) {
					errorMsg =errorMsg+ '<br/>错误信息:' + data.info
				}
				$.messager.alert('操作提示',errorMsg,"error");
	
	
		}					

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
	
   ///***************************************统一的封装控件——表达式和多行文本框(开始)**************************************************/

	//创建表达式控件
	function CreateExpDom(jq1,jq2,baseId){
		
		var target=$(jq1).find('td[field='+jq2+'] input')
		var targetf=$(jq1).find('td[field='+jq2+'F] input')
		var target1=$(jq1).find('td[field='+jq2+'] input:eq(1)')
		//detailstr[jq2]=targetf.val();
		
		target.change(function(){
			if(target.val()==""){
				targetf.val('')
			}
		})
		target.click(function(){
			var expValue=targetf.val() //表达式控件的值
			if(expValue=="")
			{
				//alert(target1.offset().top+"^"+target1.offset().left)
				var options = target.combogrid("grid").datagrid("options");		
				options.url = $URL+"?ClassName=web.DHCBL.MKB.MKBTermProDetail&MethodName=GetTermListForDoc&base="+baseId,
				options.onClickRow=function (rowIndex, rowData){
					var selected = cbg.combogrid('grid').datagrid('getSelected');  
					if (selected) { 
						//ClickDiagCombo(selected.MKBTRowId,selected.MKBTCode,selected.MKBTDesc,selected.comDesc)
						ClickDiagCombo(selected.MKBTRowId)
					}
					setTimeout(function(){
						SelMRCICDRowid=$("#SelMKBRowId").val()
				    	var indexTemplate=tkMakeServerCall("web.DHCBL.MKB.SDSStructDiagnos","GetPropertyIdByFlag",SelMRCICDRowid,"DT");
				    	//alert(SelMRCICDRowid+"^"+indexTemplate)
				    	CreatPropertyDom(target1,SelMRCICDRowid,"",indexTemplate);
			    	},10)
				}
			}
			else
			{
				
				SelMRCICDRowid=expValue.split("-")[0]; //诊断id
	        	$("#SelMKBRowId").val(SelMRCICDRowid);
		    	var indexTemplate=tkMakeServerCall("web.DHCBL.MKB.SDSStructDiagnos","GetPropertyIdByFlag",SelMRCICDRowid,"DT");
		    	//alert(SelMRCICDRowid+"^"+indexTemplate)
		    	CreatPropertyDom(target1,SelMRCICDRowid,expValue,indexTemplate);
			}
			//属性列表确定按钮功能
			$("#confirm_btn_Property").unbind('click').click(function(){
				var paramStr=GetParamStr("");
				targetf.val(paramStr)		
				var detail=tkMakeServerCall('web.DHCBL.MKB.MKBKLMappingDetail','GetExpDesc',paramStr)
				var ed=$("#mygrid").datagrid("getEditor",{index:editIndex,field:jq2});
				$(ed.target).combogrid('setValue', detail)
				$("#mypropertylist").hide();	
			})
		});
	
	}
	//属性列表取消按钮功能
	$("#cancel_btn_Property").click(function (e) { 
		$("#mypropertylist").hide();	
	}) 
	
	//创建可编辑属性列表控件
	///SelMRCICDRowid-诊断id，SDSRowId-id，indexTemplate-诊断模板id，top—控件显示top位置，left-控件显示left位置
	function CreatPropertyDom(target,SelMRCICDRowid,SDSRowId,indexTemplate){
			$('#Form_DiagPropertySearchGrid').datagrid('loadData',{total:0,rows:[]})
			$('#Form_DiagPropertySelectedGrid').datagrid('loadData',{total:0,rows:[]})
			$("#DiagForm").empty();
			SelPropertyData="";
			LoadPropertyData(SelMRCICDRowid,SDSRowId,indexTemplate);
			
			//再次打开时重新设置默认值，以防拖动后显示不下
			$("#mypropertylist").css("width",myProWidth+"px")
			$("#mypropertylist").css("height",myProHeight+"px")
			$('#mypromplayout').layout('panel', 'west').panel('resize',{width:myProWidth*(1/4)});
		    $('#mypromplayout').layout('panel', 'east').panel('resize',{width:myProWidth*(9/20)});
		    
			if(target.offset().top+$("#mypropertylist").height()+30>$(window).height()){
				//2019-10-15 chenying
				if((target.offset().top-$("#mypropertylist").height()-5)<0)
				{
					//偏移
					$("#mypropertylist").css({
						"top": target.offset().top-(target.offset().top+$("#mypropertylist").height()+30-$(window).height()),
						"left": $(window).width()-$("#mypropertylist").width()
					}).show();
				}
				else
				{
					//显示在上面
					$("#mypropertylist").css({
							"top": target.offset().top-$("#mypropertylist").height()-5,
							"left": $(window).width()-$("#mypropertylist").width()
						}).show();
						
				}
			}
			else{
				//显示在下面
				$("#mypropertylist").css({
					"top": target.offset().top+30,
					"left": $(window).width()-$("#mypropertylist").width()
				}).show();
			}
			$("#mypropertylayout").layout("resize");
			
			//结构化诊断属性列表拖动改变大小
			 $('#mypropertylist').resizable({
			    onStopResize:function(e){
			    	$('#mypromplayout').layout('panel', 'west').panel('resize',{width:$("#mypropertylist").width()*(1/4)});
		            $('#mypromplayout').layout('panel', 'east').panel('resize',{width:$("#mypropertylist").width()*(9/20)});
		            $("#mypropertylayout").layout("resize");
			    }
			});	 
	}
	//创建表达式控件
	/*function CreateExpDom(jq1,jq2,baseId){
		var target=$(jq1).find('td[field='+jq2+'] input')
		var targetf=$(jq1).find('td[field='+jq2+'F] input')
		
		detailstr[jq2]=targetf.val();
		//$('body').append(' <div id="baseiframe"><iframe id="upload" src="../csp/dhc.bdp.mkb.mkbknoexpression.csp'+'?base='+base+'?str='+str+' frameborder="0" width="100%" height="100%" scrolling="no"></iframe></div>')
		target.change(function(){
			if(target.val()==""){
				targetf.val('')
			}
		})
		target.click(function(){
			
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
		
		
	}*/
	
	//创建多行文本框
	function CreateTADom(jq1,jq2){   //生成textarea下拉区域
		
		var target=$(jq1).find('td[field='+jq2+'] textarea')
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
            $("#textareadom").focus(function(){
	        	//$('#knoExe').css('display','none'); 
            	$("#mypropertylist").hide();
	        }).focus().blur(function(){
                target.val($("#textareadom").val())	
				$(this).remove();
			}).keydown(function(e){
					if(e.keyCode==13){
						//$("#textareadom").hide();
						target.val($("#textareadom").val())	
					}
			}).click(stopPropagation);
		});
		
	}
	
	//改变上移下移按钮状态
	changeUpDownStatus=function(rowIndex)
	{
		if(rowIndex==0){
			$('#btnUp').linkbutton('disable');
			$('#btnFirst').linkbutton('disable');
		}
		else{
			$('#btnUp').linkbutton('enable');
			$('#btnFirst').linkbutton('enable');
		}
		var rows = $('#mygrid').datagrid('getRows');
		if ((rowIndex+1)==rows.length){
			$('#btnDown').linkbutton('disable');
		}
		else{
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
		
		//遍历列表
		var order=""   //按顺序排列的id串
		var minSeq=""   //最小的顺序
		var rows = $('#mygrid').datagrid('getRows');	
		for(var i=0; i<rows.length; i++){	
			var id =rows[i].MKBTPDRowId; //频率id
			var seq =rows[i].MKBTPDSequence; //顺序
			if (i==0)
			{
				minSeq=seq
			}
			else
			{
				if (minSeq>seq)
				{
					minSeq=seq
				}
			}
			if (order!=""){
				order = order+"^"+id
			}else{
				order = id
			}
			
		}
		if(minSeq=="")
		{
			minSeq=1
		}
		//保存拖拽后的顺序
		$.m({
			ClassName:"web.DHCBL.MKB.MKBTermProDetail",
			MethodName:"SaveDragListOrder",
			order:order,
			minSeq:minSeq
		},function(txtData){
			//alert(order+txtData)
		});

	}
	
	///上移、下移、置顶统一调用方法
	function mysort(index, type, gridname) 
	{
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
	
	///中心词 右键复制
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
        var $parent = self.parent.$;
        if ('undefined'!==typeof websys_getMWToken){
			fileName += "&MWToken="+websys_getMWToken()
		} 
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
		var id=record.MKBTPDRowId
		var url='http://192.144.152.252/dthealth/web/csp/dhc.bdp.mkb.mkbversion.csp?MKBVDataFlag='+HISUI_ClassTableName+'&MKBVDataID='+id
		if ('undefined'!==typeof websys_getMWToken){
			url += "&MWToken="+websys_getMWToken()
		}
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
		var id=record.MKBTPDRowId
		var url='dhc.bdp.mkb.mkbdatachangelog.csp?ClassName='+HISUI_ClassTableName+'&ObjectReference='+id
		if ('undefined'!==typeof websys_getMWToken){
			url += "&MWToken="+websys_getMWToken()
		}
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
	//HISUI_Funlib_Sort(HISUI_ClassTableName,'mygrid')
	//HISUI_Funlib_Translation(HISUI_SQLTableName,'mygrid','MKBTPDRowId')
	
	//范文凯全文词表界面所需接口，多层嵌套iframe时，获取属性内容的id
	getMKBTPDRowId = function(){
	    var data = $('#mygrid').datagrid('getSelected');
	    return data;
	}
};
$(init);
