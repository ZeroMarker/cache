/// 名称: 插件版结构化诊断录入
/// 描述: 包含诊断列表，属性列表，辅助功能区
/// 编写者: 基础数据平台组-高姗姗
/// 编写日期: 2019-07-16

var init = function(){
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.SDSDiagnos&pClassMethod=SaveEntity&pEntityName=web.Entity.MKB.SDSDiagnos";
	var DELETEALL_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.SDSDiagnos&pClassMethod=DeleteAll";
	this.title="结构化诊断录入"
	
	var editIndex = undefined;  //正在编辑的行index
	var findCondition="";  //诊断表达式检索条件
	
	//诊断短语放大镜控件
	function InitSDSWordDescLookUp(index){
		 $("#SDSWordDesc"+index).lookup({
		        url:$URL,
		        mode:'remote',
		        method:"Get",
		        idField: 'MKBSDRowId',    
				textField: 'MKBSDDesc',  
		        columns: [[    
		        	//{"MKBSDRowId":"6","MKBSDDesc":"2型糖尿病","MKBSDRRowId":"6||6","MKBSDRTermDr":"15879","MKBSDRExpId":"18158:38125","MKBSDRExp":"糖尿病[Ⅱ型]","MKBSDRSup":"","LinkIcd":"4213","LinkIcdDesc":"2型糖尿病","LinkIcdCode":"E11.901"}
					{field:'MKBSDDesc',title:'诊断',width:480,sortable:true},
					{field:'MKBSDRowId',title:'MKBSDRowId',width:20,sortable:true,hidden:true},
					{field:'MKBSDRRowId',title:'MKBSDRRowId',width:20,sortable:true,hidden:true},
					{field:'MKBSDRTermDr',title:'MKBSDRTermDr',width:20,sortable:true,hidden:true},
					{field:'MKBSDRExpId',title:'MKBSDRExpId',width:20,sortable:true,hidden:true},
					{field:'MKBSDRSup',title:'MKBSDRSup',width:20,sortable:true,hidden:true},
					{field:'MKBSDRExp',title:'结构化诊断',width:200,sortable:true,hidden:true},
					{field:'LinkIcdCode',title:'LinkIcdCode',width:20,sortable:true,hidden:true},
					{field:'LinkIcdDesc',title:'LinkIcdDesc',width:20,sortable:true,hidden:true}
				]],
		        pagination:true,
		        showHeader:false,
		        panelWidth:500,
		        panelHeight:300,
		        isCombo:true,
		        minQueryLen:2,
		        delay:'200',
		        queryOnSameQueryString:false,
		        queryParams:{ClassName: wordClassName,MethodName: 'GetTermListForDocViaIndex',version:wordVersion}, //数据处理工厂
		        onBeforeLoad:function(param){
			        var desc=param['q'];
			        param = $.extend(param,{desc:desc}); 
			    },onSelect:function(index,rec){
			    	editIndex=0 //$('#mygrid').datagrid("getData").total-1
			    	SelPropertyData=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnos","GetDataByValue",rec.MKBSDRTermDr,rec.MKBSDRExpId)
			    	var diagStr=rec.MKBSDRTermDr+"^"+rec.MKBSDRExp+"^"+rec.MKBSDRExpId+"^"+rec.MKBSDRSup+"^"+rec.MKBSDRowId+"^"+rec.MKBSDDesc+"^"+rec.LinkIcdCode+"^"+rec.LinkIcdDesc
			    	setTimeout(function(){ //解决项目偶发诊断短语录入后下拉面板未隐藏
			    		checkBeforeSave(rec.MKBSDRTermDr,diagStr,"Word")
			    	},300)
				}
	    });
	    $("#SDSWordDesc"+index).on('input propertychange',function(){
	    	var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+index+']');
	    	$(col).find('td[field=SDSWordDR] input').val("") //清空值
	    });
   }
   	//诊断表达式放大镜控件  本科室中心词－》本科室诊断短语－》非本科室中心词－》非本科室短语
	function InitSDSDisplayNameLookUp(index){
		 $("#SDSDisplayName"+index).lookup({
		        url:$URL,
		        mode:'remote',
		        method:"Get",
		        idField: 'MKBTRowId',    
				textField: 'MKBTDesc',    
				columns: [[    
					//诊断表达式相关列  查中心词时不返回短语相关信息
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
								 	var respinyin=pinyin.substring(0,indexSign)+"("+pinyin.substring(indexSign,pinyin.length)+")" //中心词拼音拼上小括号
								 	if (indexSign<0){
								 		indexSign=value.indexOf("[")
								 		respinyin=pinyin.substring(0,indexSign)+"["+pinyin.substring(indexSign,pinyin.length)+"]" //短语拼音拼上中括号
								 	}
								 	var indexCondition=respinyin.indexOf(findCondition.toUpperCase())
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
			                 return value1;     
			             } 
					},
					{field:'comDesc',title:'comDesc',width:80,sortable:true,hidden:true},
					{field:'MKBTCode',title:'诊断代码',width:80,sortable:true,hidden:true},
					{field:'MKBTRowId',title:'MKBTRowId',width:80,sortable:true,hidden:true},
					
					//诊断短语相关列  查短语时返回短语相关信息
					//"MKBSDRowId":"","MKBSDDesc":"","MKBSDRRowId":"||","MKBSDRTermDr":"","MKBSDRExpId":"","MKBSDRExp":"","MKBSDRSup":"","LinkIcdDesc":"","LinkIcdCode":""
					{field:'MKBSDRowId',title:'MKBSDRowId',width:20,sortable:true,hidden:true},
					{field:'MKBSDDesc',title:'诊断',width:100,sortable:true,hidden:true},
					{field:'MKBSDRRowId',title:'MKBSDRRowId',width:20,sortable:true,hidden:true},
					{field:'MKBSDRTermDr',title:'MKBSDRTermDr',width:20,sortable:true,hidden:true},
					{field:'MKBSDRExpId',title:'MKBSDRExpId',width:20,sortable:true,hidden:true},
					{field:'MKBSDRSup',title:'MKBSDRSup',width:20,sortable:true,hidden:true},
					{field:'MKBSDRExp',title:'结构化诊断',width:100,sortable:true,hidden:true},
					{field:'LinkIcdCode',title:'LinkIcdCode',width:20,sortable:true,hidden:true},
					{field:'LinkIcdDesc',title:'LinkIcdDesc',width:20,sortable:true,hidden:true}
				]],
		        pagination:true,
		        showHeader:false,
		        panelWidth:500,
		        panelHeight:300,
		        isCombo:true,
		        minQueryLen:2,
		        delay:'200',
		        queryOnSameQueryString:false,
		        queryParams:{ClassName: 'web.DHCBL.MKB.MKBTermProDetail',MethodName: 'GetTermListForDiaTemp',base:base},
		        onBeforeLoad:function(param){
		        	findCondition=param['q'];
			        var desc=param['q'];
			        param = $.extend(param,{desc:desc});
			    },
			    onSelect:function(index,rec){
			    	editIndex=0 //$('#mygrid').datagrid("getData").total-1
			    	var diagStr=""
			    	if (rec.MKBSDRowId!=""){
			    		SelPropertyData=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnos","GetDataByValue",rec.MKBSDRTermDr,rec.MKBSDRExpId)
						diagStr=rec.MKBSDRTermDr+"^"+rec.MKBSDRExp+"^"+rec.MKBSDRExpId+"^"+rec.MKBSDRSup+"^"+rec.MKBSDRowId+"^"+rec.MKBSDDesc+"^"+rec.LinkIcdCode+"^"+rec.LinkIcdDesc			    	
			    	}else{
			    		SelPropertyData=""
			    	}
			    	checkBeforeSave(rec.MKBTRowId,diagStr,"Term")
				},
				onShowPanel:function(){
					//诊断列表弹出时隐藏属性列表
			   		if($("#mypropertylist").is(":hidden")==false){
			   			$("#mypropertylist").hide();
			   		}
				}
	    });
	    $("#SDSDisplayName"+index).on('input propertychange',function(){
	    	var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+index+']');
			$(col).find('td[field=SDSTermDR] input').val("") //清空值
		    $(col).find('td[field=SDSValue] input').val("")
	    });
   }
   
   //被引用诊断表达式单元格加背景颜色
   	function flagColor(val, row, index) {
	    if ((val!="")&&(row.RefFlag=="Y")){
			return 'background-color:#FFC0CB;';
		}
	}
   
   //诊断列表列
	var columns =[[  
		  {field:'ck',checkbox:true }, 
		  {field:'SDSRowId',title:'RowId',width:40,hidden:true},
		  {field:'SDSTermDR',title:'SDSTermDR',width:60,hidden:true,editor:'validatebox'},
		  {field:'SDSDisplayName',title:'诊断表达式',width:200,formatter:function(value,rec,index){
		  		if (rec.SDSRowId==undefined){
		  			var colWidth=$('#mygrid').datagrid("getColumnOption","SDSDisplayName").width-15
			  		var str='<input id="SDSDisplayName'+index+'" class="textbox" style="width:'+colWidth+'px;" value='+value+'>'
			  		return str;
		  		}else{
		  			return value;
		  		}
		  },styler:flagColor}, 
		  {field:'SDSWordDR',title:'SDSWordDR',width:60,hidden:true,editor:'validatebox'},
		  {field:'SDSWordDesc',title:'诊断短语',width:160,formatter:function(value,rec,index){
		  		if (rec.SDSRowId==undefined){
		  			if (value==undefined) value="";
		  			var colWidth=$('#mygrid').datagrid("getColumnOption","SDSWordDesc").width-15
			  		var str='<input id="SDSWordDesc'+index+'" class="textbox" style="width:'+colWidth+'px;" value='+value+'>'
			  		return str;
		  		}else{
		  			return value;
		  		}
		  }},
		  {field:'SDSValue',title:'SDSValue',width:60,hidden:true,editor:'validatebox'},
		  {field:'SDSSupplement',title:'补充诊断',width:80,hidden:true,editor:'validatebox'},
		  {field:'SDSLevel',title:'级别',width:40},
		  {field:'SDSMainDiagFlag',title:'主诊断',width:60,editor:{
			  	type:'combobox', 
			  	options:{
	                 	panelWidth:110,
	                 	panelHeight:66,
	                 	editable: false,
						multiple:false,
						mode:"local",
						method: "GET",
						selectOnNavigation:true,
	                 	valueField:'value',
						textField:'text',
						data:[
							{value:'N',text:'否'},
							{value:'Y',text:'是'}
						],
						onSelect:function(rec){
							var record=$("#mygrid").datagrid("getSelected")
							if (record){
								if (record.SDSRowId==undefined){
									return;
								}
								var oldMainDiagFlag=record.SDSMainDiagFlag
								var newMainDiagFlag=rec.value
								if ((oldMainDiagFlag=="Y")&&(newMainDiagFlag=="N")){
									$.messager.alert('错误提示',"请先维护一条主诊断","error");
									return false;
								}
								$.ajax({
									url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.SDSDiagnos&pClassMethod=SaveMainDiagFlag",
									data:{
										"rowid":record.SDSRowId,
										"PatientID":PatientID,
										"mradm":mradm,
										"mainDiagFlag":newMainDiagFlag
									},  
									type:"POST",   
									success: function(data){
											  var data=eval('('+data+')'); 
											  if (data.success == 'true') {
											  		UpdataRow($("#mygrid").datagrid("getRowIndex",record),data.id)
											  } 
											  else { 
													$.messager.alert('操作提示',"保存失败！","error");
											  }			
									 }  
								})
							}
						}
				}
		  	},
		  	formatter:function(value,row,index){  
					if(value=="N"){
						return "否";
					}
					if(value=="Y"){
						return "是";
					}
			}},
		  {field:'SDSTagDR',title:'诊断标记id',width:40,hidden:true,editor:'validatebox'},
		  {field:'SDSTag',title:'诊断标记',width:80,editor:'validatebox'},
		  {field:'SDSTypeDR',title:'诊断类型',width:80,editor:{
			  	type:'combobox', 
			  	options:{
	                 	panelWidth:110,
	                 	panelHeight:160,
	                 	editable: false,
						multiple:false,
						mode:'remote',
						url:$URL+"?ClassName=web.DHCBL.MKB.SDSDiagnos&QueryName=GetTypeForCmb1&ResultSetType=array&type="+ServerObject.Type+"&scene="+ServerObject.Scene,
						valueField:'MKBTRowId',
						textField:'MKBTDesc',
						//delay:500
						onSelect:function(rec){
							var record=$("#mygrid").datagrid("getSelected")
							if (record){
								if (record.SDSRowId==undefined){
									return;
								}
								$.ajax({
									url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.SDSDiagnos&pClassMethod=SaveDiagType",
									data:{
										"rowid":record.SDSRowId,
										"typedr":rec.MKBTRowId
									},  
									type:"POST",   
									success: function(data){
											  var data=eval('('+data+')'); 
											  if (data.success == 'true') {
											  		UpdataRow($("#mygrid").datagrid("getRowIndex",record),data.id)
											  } 
											  else { 
													$.messager.alert('操作提示',"保存失败！","error");
											  }			
										 }  
									})
								}
							}
						}
				},
				formatter:function(value,row,index){  
						return row.SDSTypeDesc;
				}
		  },
		  {field:'SDSStatusDR',title:'诊断状态',width:80,editor:{
			  	type:'combobox', 
			  	options:{
	                 	panelWidth:110,
	                 	panelHeight:125,
	                 	editable: false,
						multiple:false,
						mode:'remote',
						url:$URL+"?ClassName=web.DHCBL.MKB.SDSDiagnos&QueryName=GetStatusForCmb1&ResultSetType=array",
						valueField:'MKBTRowId',
						textField:'MKBTDesc',
						//delay:500
						onSelect:function(rec){
							var record=$("#mygrid").datagrid("getSelected")
							if (record){
								if (record.SDSRowId==undefined){
									return;
								}
								$.ajax({
									url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.SDSDiagnos&pClassMethod=SaveDiagStatus",
									data:{
										"rowid":record.SDSRowId,
										"statusdr":rec.MKBTRowId
									},  
									type:"POST",   
									success: function(data){
											  var data=eval('('+data+')'); 
											  if (data.success == 'true') {
											  		UpdataRow($("#mygrid").datagrid("getRowIndex",record),data.id)
											  } 
											  else { 
													$.messager.alert('操作提示',"保存失败！","error");
											  }			
										 }  
									})
								}
							}
						}
				},
				formatter:function(value,row,index){  
						return row.SDSStatusDesc;
				}
		  },
		  {field:'SDSIcdCode',title:'关联ICD',width:100,
			formatter:function(value,rec,index){ 
				return '<span class="hisui-tooltip" title="'+rec.SDSIcdDesc+'">'+rec.SDSIcdCode+'</span>'
			}},
		  {field:'SDSIcdDesc',title:'ICD描述',width:80,hidden:true,editor:'validatebox'},
		  {field:'IcdRowId',title:'ICDID',width:40,hidden:true},
		  {field:'DiagTypeId',title:'DiagTypeId',width:40,hidden:true},
		  {field:'DiagStatusId',title:'DiagStatusId',width:40,hidden:true},
		  {field:'SDSOpenDate',title:'诊断日期',width:120,editor:'validatebox'}, 
		  {field:'SDSOnsetDate',title:'发病日期',width:60,hidden:true,editor:'validatebox'},
		  {field:'SDSSequence',title:'顺序',width:40,hidden:true},
		  {field:'SelPropertyData',title:'SelPropertyData',width:40,hidden:true,editor:'validatebox'},
		  {field:'RefFlag',title:'引用标识',width:40,hidden:true},
		  {field:'UserName',title:'医生',width:40,hidden:true}
	]];

	//诊断列表
	var isdblclick;
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.MKB.SDSDiagnos",         ///调用Query时
			QueryName:"GetList",
			'PatientID':PatientID,
			'mradm':mradm,
			'page': 1,
			'rows': 1000
		},
		columns: columns,  //列信息
		checkbox:true,
		checkOnSelect:true,//如果设置为 true，当用户点击某一行时，则会选中/取消选中复选框。如果设置为 false 时，只有当用户点击了复选框时，才会选中/取消选中复选框
		selectOnCheck:false,//如果设置为 true，点击复选框将会选中该行。如果设置为 false，选中该行将不会选中复选框
		pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		singleSelect:false, ///true, 
		idField:'SDSRowId', 
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		toolbar:'#mytbar',
		onClickRow:function(rowIndex,rowData){
			var rows=$(this).datagrid("getSelectedRowIndexs");
			if(rows.length>0){
				isdblclick=false;
				window.setTimeout(rowclickFn, 100);
		    	function rowclickFn(){
		    		if(isdblclick!=false)return;
					
					ClickFun(rowIndex)
					$("#mypropertylist").hide();
					$("#myTaglist").hide();
					$("#myDatelist").hide();
				}
	    	}
		},
		onDblClickCell: function(index,field,value){
			isdblclick=true;
			$(this).datagrid('selectRow',index);
			$(this).datagrid('beginEdit', index);
			var ed = $(this).datagrid('getEditor', {index:index,field:field});
			if (ed!=null){
				$(ed.target).focus();
			}
			editIndex=index;
			//加载诊断标记布局
			var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+index+']');
			var row = $('#mygrid').datagrid('getRows')[index];
			CreatTagDom(col,"SDSTag",index)
			var OnsetDate=row.SDSOnsetDate
			var OpenDate=row.SDSOpenDate
			CreatDateDom(col,"SDSOpenDate",index,OnsetDate,OpenDate)	
			
			ClickFun(index)
			if ((field=="SDSDisplayName")&&(row.SDSTermDR!=undefined)){
				$("#SelMKBRowId").val(row.SDSTermDR);
				var indexTemplate=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnos","GetPropertyIdByFlag",row.SDSTermDR,"DT");
				var target=$(col).find('td[field=SDSDisplayName]')
				SelPropertyData=""
				CreatPropertyDom(target,row.SDSTermDR,row.SDSRowId,indexTemplate);
			}
		},
		onRowContextMenu: function(e, rowIndex, rowData){   //右键菜单
			e.preventDefault();  //阻止浏览器捕获右键事件
			if ((rowData.SDSRowId!="")&&(rowData.SDSRowId!=undefined)){
				$(this).datagrid("selectRow", rowIndex); //根据索引选中该行  
				$('#myMenu').menu('show', {    
					  left:e.pageX,  
					  top:e.pageY
				})
			}
		},
		onSelect:function (rowIndex, rowData){
			var rows=$(this).datagrid("getSelectedRowIndexs");
			for(var i=0;i<rows.length;i++){
				var index=rows[i]
				if(index==rowIndex){
					continue;
				}	
				$(this).datagrid('unselectRow',index);
			}
		},
		onLoadSuccess:function(data){
			$('#mygrid').datagrid('clearSelections');
			AddData("");
		}
	});
	
	setTimeout(function(){
		//医生站传入诊断描述处理
		if (ServerObject.Type=="MR"){
			if ((ServerObject.DiagDesc!="")&&(ServerObject.DiagDesc!=null)){
				var diagLen=ServerObject.DiagDesc.split("^").length
				for (var i=0;i<diagLen;i++){
					var DiagDesc=ServerObject.DiagDesc.split("^")[i]
					var rowid=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnos","GetIdByWordDesc",PatientID,DiagDesc);
					if (rowid!=""){ //诊断列表中存在传入的诊断则直接勾选
						var index=$('#mygrid').datagrid('getRowIndex',rowid);
						$('#mygrid').datagrid('checkRow',index);
						if (diagLen==1){
							$('#mygrid').datagrid('scrollTo',index);
						}
					}else{ //诊断列表中不存在传入的诊断则新增后再勾选
						var resFactory=tkMakeServerCall(wordClassName,"GetSameDiag",wordVersion,DiagDesc);
						if (resFactory!=""){
							if(AddData("")==false){
								return;
							}
							var TermDR=resFactory.split("^")[3]
							var DisplayName=""
							var SDSValue=resFactory.split("^")[4]
							var SDSSupplement=resFactory.split("^")[5]
							var WordDR=resFactory.split("^")[0]
							var WordDesc=DiagDesc
							var LinkIcdCode=resFactory.split("^")[1]
							var LinkIcdDesc=resFactory.split("^")[2]
							var diagStr=TermDR+"^"+DisplayName+"^"+SDSValue+"^"+SDSSupplement+"^"+WordDR+"^"+WordDesc+"^"+LinkIcdCode+"^"+LinkIcdDesc
				    		saveRowValue(diagStr,"MR") //诊断行保存
						}
					}
				}
			}
		}
		//电子病历传入诊断类型处理
		if (ServerObject.Type=="EMR"){
			if ((ServerObject.DiagType!="")&&(ServerObject.DiagType!=null)){
				var diagIds=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnos","GetIdsByTypeDesc",PatientID,mradm,ServerObject.DiagType);
				if (diagIds!=""){
					var diagLen=diagIds.split("^").length
					for (var i=0;i<diagLen;i++){
						var rowid=diagIds.split("^")[i];
						var index=$('#mygrid').datagrid('getRowIndex',rowid);
						$('#mygrid').datagrid('checkRow',index);
					}
				}
			}
		}
	},1000) //医大一:800;青医：1200;
	
	function ClickFun(rowIndex){
		var row = $('#mygrid').datagrid('getRows')[rowIndex];
		
		//选中行id及补充诊断赋值
		$("#SelSDSRowId").val(row.SDSRowId)
		$("#SelSDSSupplement").val(row.SDSSupplement)
		
		//获取当前选中tab				
		var myTab = $('#myTabs').tabs('getSelected');					
		var tabIndex = $('#myTabs').tabs('getTabIndex',myTab);	
		if (tabIndex==1){
			//修改历史加载
			$('#SearchLog').searchbox('setValue','')
			RemoveLogDetail();
			GetLogDetail(row.SDSRowId,"")
		}
		if (tabIndex==2){
			if (row.SDSTermDR==undefined){ //未保存诊断
				var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+rowIndex+']');
				var SDSTermDR=$(col).find('td[field=SDSTermDR] input').val()
				if (SDSTermDR!=""){
					var SDSIcdCode=$(col).find('td[field=SDSIcdCode] span').html()
		    		var SDSIcdDesc=$(col).find('td[field=SDSIcdDesc] input').val()
	    			var SDSValue=$(col).find('td[field=SDSValue] input').val()
	    			InitSmartTip(SDSTermDR,"init",SDSIcdCode+"^"+SDSIcdDesc,SDSValue)
				}else{
					RemoveSmartTip();
				}
			}else{ //已保存诊断
				InitSmartTip(row.SDSTermDR,"init",row.SDSIcdCode+"^"+row.SDSIcdDesc,"")
			}
		}
		changeUpDownStatus(rowIndex);
	}

	//默认诊断开立日期
	function myformatter(date){  
        var y = date.getFullYear();  
        var m = date.getMonth()+1;  
        var d = date.getDate();  
        if (DateFormat=="j/n/Y"){
			return (d<10?('0'+d):d)+'/'+(m<10?('0'+m):m)+'/'+y;         
        }else{
        	return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);  
        }
    } 
    
    //修改完后给这一行赋值
	function UpdataRow(index,id){
		$.cm({
			ClassName:"web.DHCBL.MKB.SDSDiagnos",
			QueryName:"GetList",
			PatientID:PatientID,
			mradm:mradm,
			rowid:id
		},function(jsonData){
			$("#mypropertylist").hide();
			$("#myTaglist").hide();
			$("#myDatelist").hide();
			$('#mygrid').datagrid('updateRow',{
				index: index,
				row:jsonData.rows[0]
			})
		})
	}
    /*****************************诊断列表可编辑弹窗功能开始*****************************************************************/
    //创建可编辑属性列表控件
	function CreatPropertyDom(target,SelMRCICDRowid,SDSRowId,indexTemplate){
			$('#Form_DiagPropertySearchGrid').datagrid('loadData',{total:0,rows:[]})
			$('#Form_DiagPropertySelectedGrid').datagrid('loadData',{total:0,rows:[]})
			$("#DiagForm").empty();
			$('#Form_DiagPropertySearchText').searchbox('setValue','')
			$HUI.radio("#SearchModeA").uncheck(); 
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
						"left": target.offset().left +180
					}).show();
				}
				else
				{
					//显示在上面
					$("#mypropertylist").css({
							"top": target.offset().top-$("#mypropertylist").height()-5,
							"left": target.offset().left +180
						}).show();
						
				}
			}
			else{
				//显示在下面
				$("#mypropertylist").css({
					"top": target.offset().top+30,
					"left": target.offset().left +180
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
	//属性列表确定
	$("#confirm_btn_Property").click(function (e) { 
		var propertyValue=GetPropertyValue("1");
		var SDSTermDR=propertyValue.split("#")[0];
		var SDSValue=propertyValue.split("#")[1];
		var SDSSupplement=propertyValue.split("#")[2];
		var resultRequired=propertyValue.split("#")[3]; //必填项未维护结果集 
		if ((resultRequired!="")&&(resultRequired!=undefined)){
			$.messager.alert('错误提示',resultRequired+'不能为空!',"error");
			return;
		}
		var resWordICD=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnos","GetWordICD",SDSTermDR,SDSValue,SDSSupplement); //根据表达式获取短语及短语关联ICD
		saveRowValue(resWordICD,"") //诊断行保存
		
		$("#SelMKBRowId").val("");
	}) 
	//属性列表取消
	$("#cancel_btn_Property").click(function (e) { 
		
		$("#SelMKBRowId").val("");
		$("#mypropertylist").hide();	
		var record=$('#mygrid').datagrid('getRows')[editIndex]
		if (record.SDSRowId==undefined){ //诊断未赋值时，诊断行赋值清空
			var emptyValue= "^^^^^^^";
			setRowValue(emptyValue)
			$("#mygrid").datagrid("selectRow",editIndex)
			changeUpDownStatus(editIndex) //禁用位置移动
			var editingcol=$('#layoutcenter').children().find('tr[datagrid-row-index='+editIndex+']');
			$(editingcol).find('td[field=SDSDisplayName]').find("input").focus();
			RemoveSmartTip(); //清空智能提示
		}else{
			InitSmartTip(record.SDSTermDR,"init",record.SDSIcdCode+"^"+record.SDSIcdDesc,"") //重载智能提示		
		}
	})
	
	function stopPropagation(e){
		if (e.stopPropagation){
			e.stopPropagation();
		}else{
			e.cancelBubble=true;
		}
	}
	//属性列表隐藏(鼠标移除)
	$(document).bind('click',function(){ 
		if ($("#mygrid").datagrid("getSelected")){
		    $("#mypropertylist").hide();	
		}
	}); 
	
	$("#mypropertylist").bind('click',function(e){ 
	    stopPropagation(e); 
	}); 
	//辅助功能区设置点击医为智能提示时不可隐藏属性列表
	$("#smartlayout").bind('click',function(e){ 
	    stopPropagation(e); 
	});
	//属性列表设置点击右键菜单时不可隐藏属性列表
	$("#RightMenu").bind('click',function(e){ 
	    stopPropagation(e); 
	}); 
	$("#NodeMenu").bind('click',function(e){ 
	    stopPropagation(e); 
	}); 
	$("#selProMenu").bind('click',function(e){ 
	    stopPropagation(e); 
	}); 
	
	//创建可编辑标记列表控件
	function CreatTagDom(jq1,jq2,index){
		var target=$(jq1).find('td[field='+jq2+'] input')
		target.click(function(){
			$("#mygrid").datagrid("selectRow",index)
			var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+index+']');
			var CheckedTagStr=$(col).find('td[field=SDSTagDR] input').val() //获取已维护诊断标记
			$("#SelTagStr").val(CheckedTagStr)
			$('#Form_TagSearchGrid').datagrid('loadData',{total:0,rows:[]})
			$('#Form_TagSelectedGrid').datagrid('loadData',{total:0,rows:[]})
			$("#TagForm").empty();
			indexTagParent=""
			SelTagData=""
			LoadTagData(CheckedTagStr,"");
			//再次打开时重新设置默认值，以防拖动后显示不下
			$("#myTaglist").css("width",myProWidth+"px")
			$("#myTaglist").css("height",myProHeight+"px")
			$('#mytagmplayout').layout('panel', 'west').panel('resize',{width:myProWidth*(1/4)});
		    $('#mytagmplayout').layout('panel', 'east').panel('resize',{width:myProWidth*(9/20)});
			if(target.offset().top+$("#myTaglist").height()+30>$(window).height()){
				//2019-10-15 chenying
				if((target.offset().top-$("#myTaglist").height()-5)<0)
				{
					//偏移
					$("#myTaglist").css({
						"top": target.offset().top-(target.offset().top+$("#myTaglist").height()+30-$(window).height()),
						"left": target.offset().left +80
					}).show();
				}
				else
				{
					//显示在上面
					$("#myTaglist").css({
							"top": target.offset().top-$("#myTaglist").height()-5,
							"left": target.offset().left +80
						}).show();
						
				}
			}
			else{
				//显示在下面
				$("#myTaglist").css({
					"top": target.offset().top+30,
					"left": target.offset().left +80
				}).show();
			}
			$("#mytaglayout").layout("resize");
			
			//结构化诊断属性列表拖动改变大小
			 $('#myTaglist').resizable({
			    onStopResize:function(e){
			    	$('#mytagmplayout').layout('panel', 'west').panel('resize',{width:$("#myTaglist").width()*(1/4)});
		            $('#mytagmplayout').layout('panel', 'east').panel('resize',{width:$("#myTaglist").width()*(9/20)});
		            $("#mytaglayout").layout("resize");
			    }
			});	 
		})
	}
	//标记列表确定
	$("#confirm_btn_Tag").click(function (e) {
		var tagValue=GetTagValue();
		var SDSTagDR=tagValue.split("#")[0];
		var SDSTag=tagValue.split("#")[1];
		var record=$("#mygrid").datagrid("getSelected")
		if ((record.SDSRowId!="")&&(record.SDSRowId!=undefined)){ //SDSRowId不为空时，点保存按钮即保存
			$.ajax({
				url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.SDSDiagnos&pClassMethod=SaveTag",
				data:{
					"rowid":record.SDSRowId,
					"PatientID":PatientID,
					"mradm":mradm,
					"SDSTagDR":SDSTagDR
				},  
				type:"POST",   
				success: function(data){
						  var data=eval('('+data+')'); 
						  if (data.success == 'true') {
						  		UpdataRow($("#mygrid").datagrid("getRowIndex",record),data.id)
						  } 
						  else { 
								$.messager.alert('操作提示',"保存失败！","error");
						  }			
				 }  
			})
		}else{ 
			var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+$("#mygrid").datagrid("getRowIndex",record)+']');
			var SDSTermDR=$(col).find('td[field=SDSTermDR] input').val()
			var SDSWordDR=$(col).find('td[field=SDSWordDR] input').val()
			//未维护表达式及短语时仅赋值
			$(col).find('td[field=SDSTagDR] input').val(SDSTagDR)
			$(col).find('td[field=SDSTag] input').val(SDSTag)
			 //已维护表达式或短语时，点击保存按钮即保存
			if((SDSWordDR!="")||(SDSTermDR!="")){   
		    	var SDSValue=$(col).find('td[field=SDSValue] input').val()
		    	var SDSSupplement=$(col).find('td[field=SDSSupplement] input').val()
		    	var SDSIcdCode=$(col).find('td[field=SDSIcdCode] span').html()
		    	var SDSIcdDesc=$(col).find('td[field=SDSIcdDesc] input').val()
		    	var diagStr=SDSTermDR+"^^"+SDSValue+"^"+SDSSupplement+"^"+SDSWordDR+"^^"+SDSIcdCode+"^"+SDSIcdDesc
		    	saveRowValue(diagStr,"") //诊断行保存
			}
			$("#myTaglist").hide();
		}
	});
	//标记列表取消
	$("#cancel_btn_Tag").click(function (e) {
		$("#myTaglist").hide();	
	});
	//诊断标记列表隐藏(鼠标移除)
    $(document).bind('click',function(){ 
	    $("#myTaglist").hide();	
	}); 
	
	$("#myTaglist").bind('click',function(e){ 
	    stopPropagation(e); 
	}); 
	$("#selTagMenu").bind('click',function(e){ 
	    stopPropagation(e); 
	});
	
	//创建可编辑日期控件
	function CreatDateDom(jq1,jq2,index,OnsetDate,OpenDate){
			var target=$(jq1).find('td[field='+jq2+'] input')
			target.click(function(){
				$("#mygrid").datagrid("selectRow",index)
				LoadDateData(index,OnsetDate,OpenDate);
				if(target.offset().top+$("#myDatelist").height()+35>$(window).height()){
					$("#myDatelist").css({
						"top": target.offset().top-$("#myDatelist").height()-25,
						"left": target.offset().left
					}).show();
				}
				else{
					$("#myDatelist").css({
						"top": target.offset().top+30,
						"left": target.offset().left
					}).show();
				}
			})
		    //发病日期赋值
		    $('#SDSOnsetDate').datebox({
				onSelect: function(date){
					var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+editIndex+']');
					$(col).find('td[field=SDSOnsetDate] input').val(myformatter(date))
				}
			});
			//开立日期赋值
		    $('#SDSOpenDate').datebox({
				onSelect: function(date){
					var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+editIndex+']');
					$(col).find('td[field=SDSOpenDate] input').val(myformatter(date))
				}
			});
	}
	//日期列表赋值
	function LoadDateData(index,OnsetDate,OpenDate){
		if (OpenDate==""){
			//开立日期设置默认值
			var myOpenDate = myformatter(new Date()); 
			$('#SDSOpenDate').datebox('setValue',myOpenDate);
		}else{
			$('#SDSOpenDate').datebox('setValue',OpenDate);
		}
		if (OnsetDate==""){
			var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+index+']');
			var colOnsetDate=$(col).find('td[field=SDSOnsetDate] input').val()
			if (colOnsetDate==""){
				//发病日期设置默认值
				var myOnsetDate = myformatter(new Date()); 
				$('#SDSOnsetDate').datebox('setValue',myOnsetDate);
			}else{
				$('#SDSOnsetDate').datebox('setValue',colOnsetDate);
			}
		}else{
			$('#SDSOnsetDate').datebox('setValue',OnsetDate);
		}
	}
    //日期列表确定
	$("#confirm_btn_Date").click(function (e) {
		var OnsetDate= $('#SDSOnsetDate').datebox('getValue');
		var OpenDate= $('#SDSOpenDate').datebox('getValue');
		if (OnsetDate==""){
			$.messager.alert('错误提示','发病日期不能为空!',"error");
			return;
		}
		if ((OnsetDate!="")&&(OpenDate!="")){
			var OnsetDateComp= OnsetDate.replace("-","/");//替换字符，变成标准格式  
			OnsetDateComp= new Date(Date.parse(OnsetDateComp)); //发病日期
			var OpenDateComp= OpenDate.replace("-","/");//替换字符，变成标准格式  
			OpenDateComp= new Date(Date.parse(OpenDateComp)); //开立日期
			if(OnsetDateComp>OpenDateComp){
				$.messager.alert('错误提示','发病日期不能大于开立日期!',"error");
				return;
			}
		}
		var record=$("#mygrid").datagrid("getSelected")
		if ((record.SDSRowId!="")&&(record.SDSRowId!=undefined)){ //SDSRowId不为空时，点保存按钮即保存
			$.ajax({
				url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.SDSDiagnos&pClassMethod=SaveDate",
				data:{
					"rowid":record.SDSRowId,
					"OnsetDate":OnsetDate
				},  
				type:"POST",   
				success: function(data){
						  var data=eval('('+data+')'); 
						  if (data.success == 'true') {
						  		UpdataRow($("#mygrid").datagrid("getRowIndex",record),data.id)
						  } 
						  else { 
								$.messager.alert('操作提示',"保存失败！","error");
						  }			
				 }  
			})
		}else{ 
			var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+$("#mygrid").datagrid("getRowIndex",record)+']');
			var SDSTermDR=$(col).find('td[field=SDSTermDR] input').val()
			var SDSWordDR=$(col).find('td[field=SDSWordDR] input').val()
			//未维护表达式及短语时仅赋值
			$(col).find('td[field=SDSOnsetDate] input').val(OnsetDate)
			 //已维护表达式或短语时，点击保存按钮即保存
			if((SDSWordDR!="")||(SDSTermDR!="")){   
		    	var SDSValue=$(col).find('td[field=SDSValue] input').val()
		    	var SDSSupplement=$(col).find('td[field=SDSSupplement] input').val()
		    	var SDSIcdCode=$(col).find('td[field=SDSIcdCode] span').html()
		    	var SDSIcdDesc=$(col).find('td[field=SDSIcdDesc] input').val()
		    	var diagStr=SDSTermDR+"^^"+SDSValue+"^"+SDSSupplement+"^"+SDSWordDR+"^^"+SDSIcdCode+"^"+SDSIcdDesc
		    	saveRowValue(diagStr,"") //诊断行保存
			}
			$("#myDatelist").hide();	
		}
	});
	//日期列表取消
	$("#cancel_btn_Date").click(function (e) {
		$("#myDatelist").hide();	
	});

	//日期列表隐藏(鼠标移除)
    $(document).bind('click',function(){ 
	    $("#myDatelist").hide()	
	}); 
	
	$("#myDatelist").bind('click',function(e){ 
	    stopPropagation(e); 
	}); 
	//发病日期、治愈日期点击时不可隐藏日期列表
	$(".calendar").bind('click',function(e){ 
	    stopPropagation(e); 
	}); 
	$(".datebox-button").bind('click',function(e){ 
	    stopPropagation(e); 
	}); 
	
	//右键菜单复用按钮
	$("#CopyList").click(function(e){CopyData()})
	//复制方法
	CopyData=function(){
		var record = $("#mygrid").datagrid("getSelected"); 
		var oldSDSRowId=record.SDSRowId
		var oldIndex=mygrid.getRowIndex(record)
		if ((MKBNSFlag=="N")&&(record.SDSIcdCode=="")){
			$.messager.alert('错误提示','不允许录入非标ICD诊断!',"error");
			return false;
		}
		if(AddData("")==false){
			return;
		}
		editIndex=0;
		record.SDSRowId=""
		record.SDSValue=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnosProperty","GetParamStr",oldSDSRowId).split("-")[1];
		record.SDSOpenDate=myformatter(new Date())
		record.SDSSequence=""
		record.SDSPMIDR=PatientID
		record.SDSAdmDR=mradm
    	//执行保存
		$.ajax({
			type: 'post',
			url: SAVE_ACTION_URL,
			data: record,
			success: function (data) { //返回json结果		
				var data=eval('('+data+')');
				if(data.success=='true'){
					 UpdataRow(oldIndex,oldSDSRowId);
					 $.cm({
							ClassName:"web.DHCBL.MKB.SDSDiagnos",
							QueryName:"GetList",
							PatientID:PatientID,
							mradm:mradm,
							rowid:data.id
						},function(jsonData){
							$("#mypropertylist").hide();
							$("#myTaglist").hide();
							$("#myDatelist").hide();
							$('#mygrid').datagrid('updateRow',{
								index: editIndex, 
								row:jsonData.rows[0]
							})
							$("#mygrid").datagrid("selectRow",editIndex) 
							changeUpDownStatus(editIndex) //禁用位置移动
							
					    	if ((record.SDSTermDR!="")&&(record.SDSTermDR!=undefined)){
					    		var TermDesc=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnos","GetTermName",record.SDSTermDR);
					    		SaveFreq(record.SDSTermDR, TermDesc,"User.SDSStructDiagnos") //诊断计频次
					    	}
							$("#SelSDSRowId").val(data.id)
							
							InitSmartTip(record.SDSTermDR,"init",record.SDSIcdCode+"^"+record.SDSIcdDesc,record.SDSValue)
    	
    						AddData("");
						})
					}
					else{
						$('#mygrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex); 
						var errorMsg="修改失败！";
						if(data.errorinfo){
							errorMsg=errorMsg+'</br>错误信息:'+data.errorinfo
						}
						$.messager.alert('错误提示',errorMsg,'error')
				   }
			}
		});
	}

	/*****************************诊断列表可编辑弹窗功能结束*****************************************************************/
    //工具条按钮
    $("#btnRefresh").click(function (e) { RefreshData() }) //重置  
    $("#btnAdd").click(function (e) { AddData("scroll") }) //新增
    $("#btnDel").click(function (e) { DelData() }) //删除
    $("#btnTerm").click(function (e) { ShowTermData() }) //知识点
    $("#btnWikipedia").click(function (e) { ShowWikipedia() }) //医为百科
    $("#btnReport").click(function (e) { ReportData() }) //上报
    //$("#btnDelLog").click(function (e) { ShowDelLog() }) //删除日志
    $("#btnTimeLine").click(function (e) { ShowTimeLine() }) //生命周期
    $("#btnReview").click(function (e) { ShowReviewData() }) //上报列表
    $("#btnRef").click(function (e) { SaveDiagnosRef()}) //引用诊断 //RefData() 
    
    //重置方法
	RefreshData=function(){
		//选中行id及补充诊断重置
		$("#SelSDSRowId").val("")
		$("#SelSDSSupplement").val("")
		editIndex = undefined;  //正在编辑的行index
		
		$('#mygrid').datagrid('reload');
		$('#mygrid').datagrid('clearSelections');
		$('#mygrid').datagrid('clearChecked');
		$('#btnUpDiag').linkbutton('enable');
		$('#btnDownDiag').linkbutton('enable');
		$('#btnFirstDiag').linkbutton('enable');
		
		if($("#mypropertylist").is(":hidden")==false){
			$("#mypropertylist").hide();	 //属性列表隐藏	
   		}
   		if($("#myTaglist").is(":hidden")==false){
   	    	$("#myTaglist").hide();	 //诊断标记列表隐藏	 
   		}
   		if($("#myDatelist").is(":hidden")==false){
   	    	$("#myDatelist").hide();	 //日期列表隐藏	 
   		}
		
		$('#SearchTemp').searchbox('setValue','')
		LoadTemp("");
		$('#SearchLog').searchbox('setValue','')
		RemoveLogDetail();
   		RemoveSmartTip();
	}
	//新增方法
	AddData=function(flagAdd){
		//点击工具条按钮新增空行
		var blankFlag=false;
		var editingRowIndexs=$('#mygrid').datagrid('getEditingRowIndexs')
		if(editingRowIndexs!=""){ //已存在可编辑行
			var editingIndex=""
			for(i=0;i<editingRowIndexs.length;i++){
				var rowIndex=editingRowIndexs[i]
				var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+rowIndex+']');
    			var SDSRowId=$(col).find('td[field=SDSRowId] div').html()
				if(SDSRowId==""){
					editingIndex=rowIndex
					blankFlag=true; //存在rowid为空的空行
				}
			}
			if (blankFlag==true){
				if (editingIndex!=""){
					if (flagAdd!=""){ //诊断表达式修改保存后无需跳转到最后一行，点新增按钮时跳转
						$('#mygrid').datagrid('scrollTo', editingIndex);
						var editingcol=$('#layoutcenter').children().find('tr[datagrid-row-index='+editingIndex+']');
						$(editingcol).find('td[field=SDSDisplayName]').find("input").focus();
					}
				}
				return;
			}
		}
		
		if (blankFlag==false){ //诊断列表没有空的可编辑行时新增一空行
			editIndex = 0 //$('#mygrid').datagrid("getData").total;
			//第一个录入的诊断默认主诊断
			var MainDiagFlag="N"
			if ((editIndex==0)&&($('#mygrid').datagrid("getData").total==0)){
				MainDiagFlag="Y"
			}
			/*$('#mygrid').datagrid('appendRow',{
				SDSDisplayName:'',
				SDSIcdCode:'',
				SDSIcdDesc:'',
				SDSMainDiagFlag:MainDiagFlag,
				SDSOpenDate:myformatter(new Date()),
				SDSOnsetDate:myformatter(new Date()),
				SDSLevel:'1',
				SDSTypeDR:defaultType,
				SDSStatusDR:defaultStatus	
			});*/
			$('#mygrid').datagrid('insertRow',{
				index: 0,	
				row: {
					SDSDisplayName:'',
					SDSIcdCode:'',
					SDSIcdDesc:'',
					SDSMainDiagFlag:MainDiagFlag,
					SDSOpenDate:myformatter(new Date()),
					SDSOnsetDate:myformatter(new Date()),
					SDSLevel:'1',
					SDSTypeDR:defaultType,
					SDSStatusDR:defaultStatus	
				}
			});
			InitSDSWordDescLookUp(editIndex)
			InitSDSDisplayNameLookUp(editIndex)
	           
			$("#SelSDSSupplement").val("") //清空补充诊断
			$('#mygrid').datagrid('beginEdit', editIndex);
			$('#mygrid').datagrid('scrollTo', editIndex);
			
			var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+editIndex+']');
			$(col).find('td[field=SDSDisplayName]').find("input").focus();
			//加载诊断标记布局
			CreatTagDom(col,"SDSTag",editIndex)
			CreatDateDom(col,"SDSOpenDate",editIndex,"","")
		}
		return true;
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
	///删除方法
	DelData=function()
	{     
		var records = $("#mygrid").datagrid("getChecked"); 
		if (records=="")
		{	$.messager.alert('错误提示','请先选择记录!',"error");
			return;
		}
		var diagIdStr=""
		$.each(records, function(index, item){
			if (item.SDSRowId==undefined){
				$('#mygrid').datagrid('deleteRow',0)
				$("#mypropertylist").hide();
				$("#myTaglist").hide();
				$("#myDatelist").hide();
			}else{
				if (diagIdStr==""){
					diagIdStr=item.SDSRowId
				}else{
					diagIdStr=diagIdStr+"^"+item.SDSRowId
				}
			}
		});  
		if (diagIdStr!=""){
			$.messager.defaults = { ok: "确定", cancel: "取消" };
			$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
				if (r){	
					$.ajax({
						url:DELETEALL_ACTION_URL,  
						data:{
							"diagIdStr":diagIdStr,     ///rowid 
							"mradm":mradm
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
										$('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
										$('#mygrid').datagrid('unselectAll');  // 清空列表选中数据
										$('#btnUpDiag').linkbutton('enable');
										$('#btnDownDiag').linkbutton('enable');
										$('#btnFirstDiag').linkbutton('enable');
										$("#mypropertylist").hide();
										$("#myTaglist").hide();
										$("#myDatelist").hide();
										RemoveLogDetail();
										RemoveSmartTip();
										
										/*****************调用HIS医生站方法***************************/
									    /*window.opener.LoadtabDiagHistoryData();
									    window.opener.ReloadDiagEntryGrid();
										window.opener.SaveMRDiagnosToEMR();*/
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
	
	//诊断保存前同名诊断校验
	function checkBeforeSave(termDr,diagStr,flag){
		if ((termDr!="")&&(termDr!=undefined)){ //表达式不为空
			var rtnValidate=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnos","ValidateDiagnos",PatientID,"",termDr)
			var flagValidate=rtnValidate.split("^")[0];
			var rowidValidate=rtnValidate.split("^")[1];
			var nameValidate=rtnValidate.split("^")[2];
			var dateValidate=rtnValidate.split("^")[3];
			if (flagValidate==1){ //有同名诊断
				$("#sameDialog").show();
				var sameDialog = $HUI.dialog("#sameDialog",{
				    resizable:true,
					modal:true,
					zIndex: 110100,  
					buttonAlign : 'center',
				    title: '同名诊断',                                                                      
				    content:'<div style="margin:10px"><div class="messager-icon messager-question"></div><div>找到同名诊断:'+nameValidate+","+dateValidate+"</div></div>",
				    buttons:[{
					            text:'复用', 
					            handler:function(){
						            	$.ajax({
											url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.SDSDiagnos&pClassMethod=SaveTag",
											data:{
												"rowid":rowidValidate,
												"PatientID":PatientID,
												"mradm":mradm,
												"SDSTagDR":tkMakeServerCall("web.DHCBL.MKB.SDSDiagnos","GetTermIdByDesc","当前诊断")
											},  
											type:"POST",   
											success: function(data){
													  var data=eval('('+data+')'); 
													  if (data.success == 'true') {
													  		var emptyValue= "^^^^^^^";
															setRowValue(emptyValue)
													  		var rowIndex = $("#mygrid").datagrid("getRowIndex",rowidValidate)
													  		UpdataRow(rowIndex,rowidValidate)
													  		$("#mygrid").datagrid("selectRow",rowIndex)
													  		changeUpDownStatus(rowIndex) //禁用位置移动
													  } 
													  else { 
															var errorMsg ="修改失败！"
															if (data.info) {
																errorMsg =errorMsg+ '<br/>错误信息:' + data.info
															}
															$.messager.alert('操作提示',errorMsg,"error");
											
													}			
											}  
										})
										$('#sameDialog').dialog('close')
									}
				            },
				            {
					            text:'新建', 
					            handler:function(){
					            	if (flag=="Word"){ //诊断短语录入，诊断行保存
					            		saveRowValue(diagStr,"") 
					            	}else{ //诊断表达式录入，诊断行赋值
					            		selectTerm(termDr,diagStr)
					            	}
									$('#sameDialog').dialog('close');
					            }
				            }]
						})
				}else{ //无同名诊断
					if (flag=="Word"){ //诊断短语录入，诊断行保存
						saveRowValue(diagStr,"") 
					}else{ //诊断表达式录入，诊断行赋值
						selectTerm(termDr,diagStr)
					}
				}
		}else{ //表达式为空
			saveRowValue(diagStr,"") //诊断短语录入，诊断行保存
		}
	}
	
	//诊断表达式选中后赋值并弹出属性列表
	function selectTerm(termDr,diagStr){
		$('#mygrid').datagrid('scrollTo', editIndex); //修复诊断列表滚到最下方，诊断模板双击录诊断时属性列表被遮挡
		//属性列表弹窗
		$("#SelMKBRowId").val(termDr);
		var indexTemplate=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnos","GetPropertyIdByFlag",termDr,"DT");
		var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+editIndex+']');
		var target=$(col).find('td[field=SDSDisplayName]')
		CreatPropertyDom(target,termDr,"",indexTemplate);
		
		//诊断行赋值
		if (diagStr==""){
    		var resWordICD=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnos","GetWordICD",termDr,"",""); //根据表达式获取短语及短语关联ICD
		}else{
			var resWordICD=diagStr
		}
		setRowValue(resWordICD)
		
		//医为智能提示加载
		var SDSIcdCode=resWordICD.split("^")[6]
		var SDSIcdDesc=resWordICD.split("^")[7]
		var SDSValue=resWordICD.split("^")[2]
		InitSmartTip(termDr,"init",SDSIcdCode+"^"+SDSIcdDesc,SDSValue)
	}

	//诊断行赋值方法
	function setRowValue(diagStr){
		//TermDR+"^"+DisplayName+"^"+SDSValue+"^"+SDSSupplement+"^"+WordDR+"^"+WordDesc+"^"+LinkIcdCode+"^"+LinkIcdDesc
		var TermDR=diagStr.split("^")[0]
		var DisplayName=diagStr.split("^")[1]
		var SDSValue=diagStr.split("^")[2]
		var SDSSupplement=diagStr.split("^")[3]
		var WordDR=diagStr.split("^")[4]
		var WordDesc=diagStr.split("^")[5]
		var SDSIcdCode=diagStr.split("^")[6]
		var SDSIcdDesc=diagStr.split("^")[7]
		
    	var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+editIndex+']');
    	$(col).find('td[field=SDSTermDR] input').val(TermDR)
    	$(col).find('td[field=SDSDisplayName] input').val(DisplayName)
    	$(col).find('td[field=SDSValue] input').val(SDSValue)
    	$(col).find('td[field=SDSSupplement] input').val(SDSSupplement)
    	$(col).find('td[field=SDSWordDR] input').val(WordDR)
    	$(col).find('td[field=SDSWordDesc] input').val(WordDesc)
    	$(col).find('td[field=SDSIcdCode] span').html(SDSIcdCode)
    	$(col).find('td[field=SDSIcdCode] span ').attr("title",SDSIcdDesc);
    	$(col).find('td[field=SDSIcdDesc] input').val(SDSIcdDesc)
    	$(col).find('td[field=SelPropertyData] input').val(SelPropertyData)
	}
	//诊断行保存方法,flag为空是结构化诊断页面保存 为MR是医生站传过的诊断保存
	function saveRowValue(diagStr,flag){
		//TermDR+"^"+DisplayName+"^"+SDSValue+"^"+SDSSupplement+"^"+WordDR+"^"+WordDesc+"^"+LinkIcdCode+"^"+LinkIcdDesc
		var TermDR=diagStr.split("^")[0]
		var DisplayName=diagStr.split("^")[1]
		var SDSValue=diagStr.split("^")[2]
		var SDSSupplement=diagStr.split("^")[3]
		var WordDR=diagStr.split("^")[4]
		var WordDesc=diagStr.split("^")[5]
		var SDSIcdCode=diagStr.split("^")[6]
		var SDSIcdDesc=diagStr.split("^")[7]
		if ((MKBNSFlag=="N")&&(SDSIcdCode=="")){
			$.messager.alert('错误提示','不允许录入非标ICD诊断!',"error");
			$("#SelMKBRowId").val("");
			$("#mypropertylist").hide();	
			var emptyValue= "^^^^^^^";
			setRowValue(emptyValue)
			$("#mygrid").datagrid("selectRow",editIndex)
			changeUpDownStatus(editIndex) //禁用位置移动
			var editingcol=$('#layoutcenter').children().find('tr[datagrid-row-index='+editIndex+']');
			$(editingcol).find('td[field=SDSDisplayName]').find("input").focus();
			return false;
		}
		var SDSMainDiagFlag="N",SDSSequence="",SDSTagDR="",SDSLevel="1",SDSOnsetDate=myformatter(new Date()),SDSTypeDR=defaultType,SDSStatusDR=defaultStatus //赋初值
		if (flag==""){
			var record=$('#mygrid').datagrid('getRows')[editIndex]
			var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+$("#mygrid").datagrid("getRowIndex",record)+']');
			SDSMainDiagFlag=$(col).find('td[field=SDSMainDiagFlag] input[type=hidden]').val()
			SDSSequence=$(col).find('td[field=SDSSequence] div').html()
			SDSTagDR=$(col).find('td[field=SDSTagDR] input').val()
			SDSLevel=$(col).find('td[field=SDSLevel] div').html()
			SDSOnsetDate=$(col).find('td[field=SDSOnsetDate] input').val()
			SDSTypeDR=$(col).find('td[field=SDSTypeDR] input[type=hidden]').val()
			SDSStatusDR=$(col).find('td[field=SDSStatusDR] input[type=hidden]').val()
		}else{
			var record = $('#mygrid').datagrid('getRows')[0]; //$('#mygrid').datagrid("getData").total-1
		}
		record.SDSTermDR=TermDR
		record.SDSValue=SDSValue
		record.SDSSupplement=SDSSupplement
		record.SDSIcdCode=SDSIcdCode
		record.SDSIcdDesc=SDSIcdDesc
		record.SDSWordDR=WordDR
		if (SDSMainDiagFlag!=undefined){ //获取可编辑状态下的主诊断值
			record.SDSMainDiagFlag=SDSMainDiagFlag
		}
		record.SDSSequence=SDSSequence
		if (SDSTagDR!=undefined){ //获取可编辑状态下的诊断标记值
			record.SDSTagDR=SDSTagDR
		}
		record.SDSLevel=SDSLevel
		record.SDSOnsetDate=SDSOnsetDate
		record.SDSTypeDR=SDSTypeDR
		record.SDSStatusDR=SDSStatusDR
		record.SDSPMIDR=PatientID
		record.SDSAdmDR=mradm
    	//执行保存
		$.ajax({
			type: 'post',
			url: SAVE_ACTION_URL,
			data: record,
			success: function (data) { //返回json结果		
				var data=eval('('+data+')');
				if(data.success=='true'){
					 $.cm({
							ClassName:"web.DHCBL.MKB.SDSDiagnos",
							QueryName:"GetList",
							PatientID:PatientID,
							mradm:mradm,
							rowid:data.id
						},function(jsonData){
							$("#mypropertylist").hide();
							$("#myTaglist").hide();
							$("#myDatelist").hide();
							$('#mygrid').datagrid('updateRow',{
								index: editIndex,
								row:jsonData.rows[0]
							})
							$("#mygrid").datagrid("selectRow",editIndex)
							changeUpDownStatus(editIndex) //禁用位置移动
							
					    	if ((TermDR!="")&&(TermDR!=undefined)){
					    		var TermDesc=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnos","GetTermName",TermDR);
					    		SaveFreq(TermDR, TermDesc,"User.SDSStructDiagnos") //诊断计频次
					    	}
							
							if (flag=="MR"){ //医生站传入的诊断保存后勾选
								$("#mygrid").datagrid("checkRow",editIndex);
							}
							$("#SelSDSRowId").val(data.id)
							
							InitSmartTip(TermDR,"init",SDSIcdCode+"^"+SDSIcdDesc,SDSValue)
    	
    						AddData("");
						})
					}
					else{
						$('#mygrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex); 
						var errorMsg="修改失败！";
						if(data.errorinfo){
							errorMsg=errorMsg+'</br>错误信息:'+data.errorinfo
						}
						$.messager.alert('错误提示',errorMsg,'error')
				   }
			}
		});
	}
	
	//查看知识点方法
	function ShowTermData(){
		var TermID="",ProId="",detailId="";
		var record = $("#mygrid").datagrid("getSelected"); 
		if (record){
			if (record.SDSTermDR!=undefined){
				TermID=record.SDSTermDR //选中已保存诊断
				var resProInfo=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnosProperty","GetPropertyNode",record.SDSRowId)
				var proCount=resProInfo.split("#")[0];
				var detailCount=resProInfo.split("#")[1];
				var proIds=resProInfo.split("#")[2];
				if (proCount==1){ //仅维护一条属性
					ProId=proIds.split(":")[0]
					if (detailCount==1){ //仅维护一条属性内容
						detailId=proIds.split(":")[1]
					}
				}
			}
		}
    	var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+$("#mygrid").datagrid("getRowIndex",record)+']');
    	var SDSTermDR=$(col).find('td[field=SDSTermDR] input').val()
    	if (SDSTermDR!=undefined){
    		TermID=SDSTermDR //选中未保存诊断
    	}
		if (TermID==undefined) TermID="";
		var height=parseInt(window.screen.height)-200;
		var width=parseInt(window.screen.width)-130;
		var repUrl="dhc.bdp.mkb.mkblistterm.csp?BDPMENU="+menuid+"&TermID="+TermID+"&ProId="+ProId+"&detailId="+detailId+""
		if ("undefined"!==typeof websys_getMWToken){
			repUrl += "&MWToken="+websys_getMWToken()
		}
		$("#myWinTerm").show();  
		var myWinTerm = $HUI.dialog("#myWinTerm",{
			resizable:true,
			title:'知识点',
			width:width,
			height:height,
			modal:true,
			content:'<iframe id="term" frameborder="0" src='+repUrl+' width="100%" height="99%"></iframe>'
		});
	}
	
	//查看医为百科方法
	function ShowWikipedia(){
		var TermID=""
		var record = $("#mygrid").datagrid("getSelected"); 
		if (record){
			if (record.SDSTermDR!=undefined){
				TermID=record.SDSTermDR //选中已保存诊断
			}
		}
    	var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+$("#mygrid").datagrid("getRowIndex",record)+']');
    	var SDSTermDR=$(col).find('td[field=SDSTermDR] input').val()
    	if (SDSTermDR!=undefined){
    		TermID=SDSTermDR //选中未保存诊断
    	}
		if ((TermID==undefined)||(TermID=="")) {
			$.messager.alert('错误提示','请先选择诊断!',"error");
			return;
		}
		var height=parseInt(window.screen.height)-200;
		var width=parseInt(window.screen.width)-100;
		var repUrl="dhc.bdp.mkb.mkbencyclopedia.csp?base="+base+"&id="+TermID+""
		if ("undefined"!==typeof websys_getMWToken){
			repUrl += "&MWToken="+websys_getMWToken()
		}
		$("#myWinWikipedia").show();  
		var myWinWikipedia = $HUI.dialog("#myWinWikipedia",{
			resizable:true,
			title:'医为百科',
			width:width,
			height:height,
			modal:true,
			content:'<iframe id="wikipedia" frameborder="0" src='+repUrl+' width="100%" height="99%"></iframe>'
		});
	}
    
	//上报方法:选中诊断未保存即为新增，已保存即为修改
	ReportData=function(){
		var record=$("#mygrid").datagrid("getSelected");
		if (!record){ //上报新增
			//PatientID^短语dr^短语描述(或简拼)^Termdr^ResultID^补充诊断^ICD代码^ICD描述^表达式描述^标识
		    var SDSStr=PatientID+"^^^^^^^^^"+flagReport;
		}else{
			if(record.SDSRowId!=undefined){ //上报修改
				var param=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnosProperty","GetParamStr",record.SDSRowId)
				var SDSValue=""
				if ((param!="")&&(param.indexOf("-")>0)){
					SDSValue=param.split("-")[1]
				}
				//PatientID^短语dr^短语描述(或简拼)^Termdr^ResultID^补充诊断^ICD代码^ICD描述^表达式描述^标识
	    		var SDSStr = PatientID+"^"+record.SDSWordDR+"^"+encodeURI(record.SDSWordDesc.replace(/\&nbsp;/g,""))+"^"+record.SDSTermDR+"^"+SDSValue+"^"+record.SDSSupplement+"^"+record.SDSIcdCode+"^"+record.SDSIcdDesc+"^"+encodeURI(record.SDSDisplayName.replace(/\&nbsp;/g, ""))+"^"+flagReport;
			}else{ //上报新增
		    	var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+$("#mygrid").datagrid("getRowIndex",record)+']');
		    	var TermDR=$(col).find('td[field=SDSTermDR] input').val()
		    	var DisplayName=$(col).find('td[field=SDSDisplayName] input').val()
		    	var SDSValue=$(col).find('td[field=SDSValue] input').val()
		    	var SDSSupplement=$(col).find('td[field=SDSSupplement] input').val()
		    	var WordDR=$(col).find('td[field=SDSWordDR] input').val()
		    	var WordDesc=$(col).find('td[field=SDSWordDesc] input').val()
		    	var LinkIcdCode=$(col).find('td[field=LinkIcdCode] span').html()
		    	var LinkIcdDesc=$(col).find('td[field=LinkIcdDesc] input').val()
		    	var SDSIcdCode=$(col).find('td[field=SDSIcdCode] span').html()
    			var SDSIcdDesc=$(col).find('td[field=SDSIcdDesc] input').val()
		    	//PatientID^短语dr^短语描述(或简拼)^Termdr^ResultID^补充诊断^ICD代码^ICD描述^表达式描述^标识
		    	var SDSStr=PatientID+"^"+WordDR+"^"+encodeURI(WordDesc)+"^"+TermDR+"^"+SDSValue+"^"+SDSSupplement+"^"+SDSIcdCode+"^"+SDSIcdDesc+"^"+encodeURI(DisplayName)+"^"+flagReport;
			}	
		}
		var repUrl="dhc.bdp.mkb.mkbdatareviewed.csp?SDSStr="+SDSStr+""
		if ("undefined"!==typeof websys_getMWToken){
			repUrl += "&MWToken="+websys_getMWToken()
		}
		$("#myWinDataReviewed").show();  
		var myWinDataReviewed = $HUI.dialog("#myWinDataReviewed",{
			iconCls:'icon-w-edit',
			resizable:true,
			title:'上报',
			width:$(window).width()*90/100,
			height:$(window).height()*92/100,
			modal:true,
			content:'<iframe id="DataReviewed" frameborder="0" src='+repUrl+' width="100%" height="99%"></iframe>'
		});
	}
	//删除日志方法
	/*function ShowDelLog(){
		$("#myWinDelLog").show();  
		var myWinDelLog = $HUI.dialog("#myWinDelLog",{
			resizable:true,
			title:'删除日志',
			width:$(window).width()*92/100,
			height:$(window).height()*92/100,
			modal:true
		});
		var dellogcolumns =[[   
					{field:'SDSWordDesc',title:'诊断短语',width:140},
					{field:'SDSDisplayName',title:'诊断表达式',width:140}, 
					{field:'SDSIcdCode',title:'关联ICD代码',width:120},
					{field:'SDSIcdDesc',title:'关联ICD描述',width:120},
					{field:'SDSMainDiagFlag',title:'主诊断',width:80,
						formatter:function(value,row,index){  
							if(value=="N"){
								return "否";
							}
							if(value=="Y"){
								return "是";
							}
						}},
					{field:'SDSInsertUser',title:'录入人',width:100},
					{field:'SDSInsertDate',title:'录入日期',width:120},
					{field:'SDSInsertTime',title:'录入时间',width:120},
					{field:'SDSUpdateUser',title:'删除人',width:100},
					{field:'SDSUpdateDate',title:'删除日期',width:120},
					{field:'SDSUpdateTime',title:'删除时间',width:120},
					{field:'SDSDiagnosId',title:'诊断ID',width:60,hidden:true},
					{field:'SDSRowId',title:'SDSRowId',width:60,hidden:true} 
				]];
		var DelLogGrid = $HUI.datagrid("#DelLogGrid",{
			url:$URL,
			queryParams:{
				ClassName:"web.DHCBL.MKB.SDSDiagnosDelLog",
				QueryName:"GetList", //安贞ICD
				PatientID:PatientID
			},
			columns: dellogcolumns,  //列信息
			pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
			pageSize:20,
			pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
			singleSelect:true,
			idField:'SDSRowId', 
			rownumbers:true,    //设置为 true，则显示带有行号的列。
			fixRowNumber:true,
			fitColumns:true
		});  
	}*/
	//查看生命周期方法
	function ShowTimeLine(){
		var repUrl="dhc.bdp.sds.diagnostimeline.csp?id="+PatientID+""
		if ("undefined"!==typeof websys_getMWToken){
			repUrl += "&MWToken="+websys_getMWToken()
		}
		$("#myWinTimeLine").show();  
		var myWinTimeLine = $HUI.dialog("#myWinTimeLine",{
			resizable:true,
			title:'诊断生命周期',
			width:$(window).width()*98/100,
			height:$(window).height()*92/100,
			modal:true,
			content:'<iframe id="TimeLine" frameborder="0" src='+repUrl+' width="99%" height="98%"></iframe>'
		});
	}
	//查看上报列表方法
	function ShowReviewData(){
		$("#myWinReviewDiag").show();  
		var myWinReviewDiag = $HUI.dialog("#myWinReviewDiag",{
			resizable:true,
			width:$(window).width()*90/100,
			height:$(window).height()*90/100,
			title:'上报列表',
			modal:true
		});
		//诊断描述
		$("#ReviewDesc").css("width",$(window).width()*16/100+"px");
		$('#ReviewDesc').keyup(function(event){
			//搜索回车事件
			if(event.keyCode == 13) {
				SearchReviewFunLib();
			}
		}); 
		//上报理由 缺诊断短语A，诊断短语不正确B，缺诊断表达式C，诊断表达式不正确D，缺ICDE，ICD不正确F
		$HUI.combobox("#ReviewReason",{
			width:$(window).width()*16/100,
			panelWidth:$(window).width()*16/100,
	     	panelHeight:215,
			//multiple:true, //多选
			mode:"local",
			method: "GET",
			selectOnNavigation:true,
			valueField:'value',
			textField:'text',
			value:'',
			data:[
				{value:'',text:'全部'},
				{value:'A',text:'缺诊断短语'},
				{value:'B',text:'诊断短语不正确'},
				{value:'C',text:'缺诊断表达式'},
				{value:'D',text:'诊断表达式不正确'},
				{value:'E',text:'缺ICD'},
				{value:'F',text:'ICD不正确'}
			],
			onSelect: function(record){
				SearchReviewFunLib();
			}
		});
		//审核状态
		$HUI.combobox("#ReviewStatus",{
			width:$(window).width()*16/100,
			panelWidth:$(window).width()*16/100,
	     	panelHeight:96,
			multiple:false,
			mode:"local",
			method: "GET",
			selectOnNavigation:true,
			valueField:'value',
			textField:'text',
			value:'',
			data:[
				{value:'',text:'全部'},
				{value:'Y',text:'已审核'},
				{value:'N',text:'未审核'}
			],
			onSelect: function(record){
				SearchReviewFunLib();
			}
		});
		var reviewcolumns =[[   
						//MKBDRRowId,MKBDRDiagDr,MKBDRDiagDesc,MKBDRDiag,MKBDRTermDR,MKBDRStructResultID,MKBDRStructDesc,MKBDRSupplement,
						//MKBDRMRCDr,MKBDRMRCCode,MKBDRMRCDesc,MKBDRICDDesc,MKBDRReson,MKBDRNote,MKBDRStatus
						{field:'MKBDRDiagDesc',title:'原诊断名',width:120},
						{field:'MKBDRDiag',title:'上报诊断名',width:120},
						{field:'MKBDRStructDesc',title:'诊断表达式',width:140}, 
						{field:'MKBDRMRCCode',title:'关联ICD',width:120},
						{field:'MKBDRICDDesc',title:'ICD描述',width:120},
						{field:'MKBDRReson',title:'上报理由',width:120},
						{field:'MKBDRNote',title:'备注',width:120},
						{field:'MKBDRStatus',title:'审核状态',width:100,
						formatter:function(value,row,index){  
								if(value=="N"){
									return "<font color=white>未审核</font>"
								}else{
									return "<font color=white>已审核</font>"
								}
						},
						styler:function(val, row, index){
							if(val=="N"){
								return 'background-color:#ff584c;'; //红色
							}else{
								return 'background-color:#15b398'; //绿色
							}
						}
						},
						{field:'MKBDRDiagDr',title:'MKBDRDiagDr',hidden:true},
						{field:'MKBDRStructChild',title:'MKBDRStructChild',hidden:true},
						{field:'MKBDRTermDR',title:'MKBDRTermDR',hidden:true}, 
						{field:'MKBDRStructResultID',title:'MKBDRStructResultID',hidden:true}, 
						{field:'MKBDRSupplement',title:'MKBDRSupplement',hidden:true}, 
						{field:'MKBDRMRCDr',title:'MKBDRMRCDr',hidden:true}, 
						{field:'MKBDRRowId',title:'MKBDRRowId',hidden:true} 
					]];
		var ReviewDiagGrid = $HUI.datagrid("#ReviewDiagGrid",{
			url:$URL,
			queryParams:{
				ClassName:"web.DHCBL.MKB.MKBDataReviewed",
				QueryName:"GetList", //安贞ICD
				mradm:"", //针对患者
				type:flagReport
			},
			columns: reviewcolumns,  //列信息
			pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
			pageSize:20,
			pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
			singleSelect:true,
			idField:'MKBDRRowId', 
			rownumbers:true,    //设置为 true，则显示带有行号的列。
			fixRowNumber:true,
			fitColumns:true,
			toolbar:'#myReviewtbar',
			onDblClickRow:function(rowIndex,rowData){
				if(rowData.MKBDRStatus!="Y"){
					$.messager.alert('错误提示','请先审核诊断!',"error");
					return;
				}
				if (rowData.MKBDRStructChild==""){
					$.messager.alert('错误提示','请查看是否维护此诊断!',"error");
					return;
				}
				if(AddData("")==false){
					return;
				}
	        	
		    	//诊断行双击录入
				var diagStr=rowData.MKBDRTermDR+"^"+rowData.MKBDRStructDesc+"^"+rowData.MKBDRStructResultID+"^"+rowData.MKBDRSupplement+"^"+rowData.MKBDRDiagDr+"^"+rowData.MKBDRDiagDesc+"^"+rowData.MKBDRMRCCode+"^"+rowData.MKBDRICDDesc
				checkBeforeSave(rowData.MKBDRTermDR,diagStr,"Word")
    			
				$("#myWinReviewDiag").dialog('close');
			}
		})
		$("#btnReviewSearch").click(function (e) { 
			SearchReviewFunLib();
		}) 
		$("#btnReviewRefresh").click(function (e) { 
			ClearReviewFunLib();
		 }) 
		SearchReviewFunLib=function (){
			var desc=$("#ReviewDesc").val();
			//var reason=$("#ReviewReason").combobox('getValues').sort().join(",") //多选情况取值
			var reason=$("#ReviewReason").combobox('getValue')
			var status=$("#ReviewStatus").combobox('getValue')
			$('#ReviewDiagGrid').datagrid('load',  { 
				ClassName:"web.DHCBL.MKB.MKBDataReviewed",
				QueryName:"GetList",
				'mradm':"", //针对患者
				'desc':desc,
				'reason':reason,
				'status':status,
				'type':flagReport
			});
			$('#ReviewDiagGrid').datagrid('unselectAll');
		}
		ClearReviewFunLib=function ()
		{
			$("#ReviewDesc").val("")
			$("#ReviewReason").combobox('setValue', '');
			$("#ReviewStatus").combobox('setValue', '');
			$('#ReviewDiagGrid').datagrid('load',  { 
				ClassName:"web.DHCBL.MKB.MKBDataReviewed",
				QueryName:"GetList",
				'mradm':"", //针对患者
				'desc':"",
				'reason':"",
				'status':"",
				'type':flagReport
			});
			$('#ReviewDiagGrid').datagrid('unselectAll');
		}
	}
	//引用诊断方法
	function SaveDiagnosRef(){
		var records = $("#mygrid").datagrid("getChecked"); 
		if (records=="")
		{	$.messager.alert('错误提示','请先选择记录!',"error");
			return;
		}
		
		//引用到医生站
		if (ServerObject.Type=="MR"){
			var diagStr="" //结构化诊断id^ICD代码^备注^主诊断^ICD代码表id^级别^发病日期^诊断类型Id^诊断状态Id
			for (var i=0;i<records.length;i++){
				if (records[i].SDSRowId!=undefined){
					if (diagStr==""){
						diagStr=records[i].SDSRowId+"^"+records[i].SDSIcdCode+"^"+records[i].SDSDisplayName.replace(/\&nbsp;/g, "")+"^"+records[i].SDSMainDiagFlag+"^"+records[i].IcdRowId+"^"+records[i].SDSLevel+"^"+records[i].SDSOnsetDate+"^"+records[i].DiagTypeId+"^"+records[i].DiagStatusId
					}else{
						diagStr=diagStr+"&"+records[i].SDSRowId+"^"+records[i].SDSIcdCode+"^"+records[i].SDSDisplayName.replace(/\&nbsp;/g, "")+"^"+records[i].SDSMainDiagFlag+"^"+records[i].IcdRowId+"^"+records[i].SDSLevel+"^"+records[i].SDSOnsetDate+"^"+records[i].DiagTypeId+"^"+records[i].DiagStatusId
					}
				}
			}
			if (diagStr==""){
				$.messager.alert('错误提示','请选择已维护记录!',"error");
				return;
			}
			if ((typeof(ServerObject.Flag)!="undefined")&&(ServerObject.Flag.indexOf("CSPLUG")>-1)){
				var flagClient=ServerObject.Flag.replace("CSPLUG","");
		        // 没有在electron里面嵌入，不可用
		      	if (window.require) {
		          	const ipcRenderer = require('electron').ipcRenderer;
		          	ipcRenderer.send('sds-message'+flagClient,diagStr);
		      	} 	
			}else{
				//window.opener.AddDiagFromStructDiags(diagStr);  //针对window.open打开窗口
				window.parent.dialogArguments.AddDiagFromStructDiags(diagStr); //针对window.showModalDialog模态框打开窗口
			}
		}
		//引用到电子病历
		if (ServerObject.Type=="EMR"){
			var DiaDataList = new Array();
			var DiaObj = new Object();
			
			var SDSCat="",SDSTypeDesc="",SDSLevel="",SDSDisplayName="",SDSIcdCode="",SDSStatusDesc="",SDSOpenDate="",UserName=""
			for (var i=0;i<records.length;i++){
				if (records[i].SDSRowId!=undefined){
					SDSCat=0;
					SDSTypeDesc=records[i].SDSTypeDesc
					SDSLevel=records[i].SDSLevel
					SDSDisplayName=records[i].SDSDisplayName.replace(/\&nbsp;/g, "")
					SDSIcdCode=records[i].SDSIcdCode
					SDSStatusDesc=records[i].SDSStatusDesc
					SDSOpenDate=records[i].SDSOpenDate
					UserName=records[i].UserName
					//分类（西医：0，中医：1），诊断类型，诊断等级，诊断描述，备注，ICD代码，诊断状态，诊断日期，操作用户
					DiaObj={BillFlagDesc:SDSCat,TypeDesc:SDSTypeDesc,Level:SDSLevel,ICDDesc:SDSDisplayName,MemoDesc:"",ICDCode:SDSIcdCode,EvaluationDesc:SDSStatusDesc,Date:SDSOpenDate,UserName:UserName};
					DiaDataList.push(DiaObj);
				}
			}
			var DiaDataList=diagnosesBtQuote(DiaDataList)
			window.returnValue=$.extend(window.returnValue,{"DiaDataList":DiaDataList});
		}
		window.close();
	}
	
	//引用诊断方法(弃用)
	function RefData(){
		var records = $("#mygrid").datagrid("getChecked"); 
		if (records=="")
		{	$.messager.alert('错误提示','请先选择记录!',"error");
			return;
		}
		var diagIdStr=""
		for (var i=0;i<records.length;i++){
			if (records[i].SDSRowId!=undefined){
				if (diagIdStr==""){
					diagIdStr=records[i].SDSRowId
				}else{
					diagIdStr=diagIdStr+"^"+records[i].SDSRowId
				}
			}
		}
		if (diagIdStr==""){
			$.messager.alert('错误提示','请选择已维护记录!',"error");
			return;
		}
		$.ajax({
				url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.SDSDiagnos&pClassMethod=SaveRefData",
				data:{
					"diagIdStr":diagIdStr,
					"PatientID":PatientID,
					"mradm":mradm
				},  
				type:"POST",   
				success: function(data){
					  var data=eval('('+data+')'); 
					  if (data.success == 'true') {
					  		
							window.top.close();
							//参数:MRDiagRowId_$c(1)_ICDRowId_"^"_MRDiagRowId_$c(1)_ICDRowId
							/*****************调用HIS医生站方法***************************/
							if (data.info!=""){
								window.opener.AfterInsertDiag(data.info);
								window.opener.SaveMRDiagnosToEMR()
								window.opener.UpdateArriveStatus()
							}else{
								window.opener.ReloadDiagEntryGrid();
							}
					  } 
					  else { 
							$.messager.alert('操作提示',"保存失败！","error");
					  }			
				 }  
			})
	}
	
	//确定前校验方法(弃用)
	/*function CheckBeforeConfirm(){
		var SavedData=""
		var EditedData=""
		var MainDiagStr=""
		var rows=$("#mygrid").datagrid("getRows")
		for(var i=0;i<rows.length;i++){
			var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+i+']');
			var SDSMainDiagFlag=$(col).find('td[field=SDSMainDiagFlag] input[type=hidden]').val()
			if (rows[i].SDSRowId!=undefined){ //已保存数据
				if (SavedData==""){
					SavedData="["+rows[i].SDSTermDR+"^"+rows[i].SDSWordDR+"]"
				}else{
					SavedData=SavedData+"["+rows[i].SDSTermDR+"^"+rows[i].SDSWordDR+"]"
				}
				if (((rows[i].SDSMainDiagFlag=="Y")&&(SDSMainDiagFlag==undefined))||(SDSMainDiagFlag=="Y")){ //已保存数据||已保存再次修改数据
					if (MainDiagStr==""){
						MainDiagStr=i
					}else{
						MainDiagStr=MainDiagStr+"*"+i
					}
				}
			}else{
				var SDSTermDR=$(col).find('td[field=SDSTermDR] input').val()
				var SDSWordDR=$(col).find('td[field=SDSWordDR] input').val()
				
		    	if((SDSTermDR=="")&&(SDSWordDR=="")){
		    		continue;
		    	}
		    	if (EditedData==""){
		    		EditedData="["+SDSTermDR+"^"+SDSWordDR+"]"
		    	}else{
		    		EditedData=EditedData+"["+SDSTermDR+"^"+SDSWordDR+"]"
		    	}
		    	if (SDSMainDiagFlag=="Y"){
		    		if (MainDiagStr==""){
						MainDiagStr=i
					}else{
						MainDiagStr=MainDiagStr+"*"+i
					}
		    	}
			}
		}
		if (""+MainDiagStr+""==""){
			$.messager.alert('错误提示','请维护主诊断!',"error");
			return false;
		}else{
			if (""+MainDiagStr+"".indexOf("*")>=0){
				$.messager.alert('错误提示','请维护一条主诊断!',"error");
				return false;
			}
		}
		if ((SavedData.indexOf(EditedData)>-1)&&(EditedData!="")){
			if(!window.confirm("所加诊断在本次诊断中已经存在,请确认是否重复增加")) {
				return false;
			}
		}
		return true;
	}*/

	//确定并关闭方法(弃用)
	/*function ConfirmData(){
		var editingRowIndexs=$('#mygrid').datagrid('getEditingRowIndexs')
		if (editingRowIndexs==""){ //没有可编辑空行时，直接关闭
			window.top.close();
			return;
		}
		var blankFlag=false;
		var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+editingRowIndexs[0]+']');
		var SDSTermDR=$(col).find('td[field=SDSTermDR] input').val()
		var SDSWordDR=$(col).find('td[field=SDSWordDR] input').val()
		if((SDSWordDR=="")&&(SDSTermDR=="")){
			blankFlag=true; //存在rowid为空的空行
		}
		if (blankFlag==true){ //有可编辑空行，但未维护诊断时，直接关闭
			window.top.close(); //(self.parent).opener.location.reload();
		}else{
			if (!CheckBeforeConfirm()) return false;
				
			var StructDiagnosResult=""
			for(i=0;i<editingRowIndexs.length;i++){
				var rowIndex=editingRowIndexs[i]
				var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+rowIndex+']');
				var SDSRowId=$(col).find('td[field=SDSRowId] div').html()
				var SDSTermDR=$(col).find('td[field=SDSTermDR] input').val()
				var SDSWordDR=$(col).find('td[field=SDSWordDR] input').val()
		    	var SDSValue=$(col).find('td[field=SDSValue] input').val()
		    	var SDSSupplement=$(col).find('td[field=SDSSupplement] input').val()
		    	var SDSIcdCode=$(col).find('td[field=SDSIcdCode] span').html()
		    	var SDSIcdDesc=$(col).find('td[field=SDSIcdDesc] input').val()
		    	var SDSOpenDate=$(col).find('td[field=SDSOpenDate] div').html()
		    	var SDSSequence=$(col).find('td[field=SDSSequence] div').html()
		    	var SDSMainDiagFlag=$(col).find('td[field=SDSMainDiagFlag] input[type=hidden]').val()
		    	
		    	if((SDSWordDR=="")&&(SDSTermDR=="")){
		    		continue;
		    	}
		    	if (SDSTermDR!=""){
		    		var SDSTermDesc=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnos","GetTermName",SDSTermDR);
		    		SaveFreq(SDSTermDR, SDSTermDesc,"User.SDSStructDiagnos") //诊断计频次
		    	}
		    	if (StructDiagnosResult==""){
		    		StructDiagnosResult=SDSRowId+"^"+SDSWordDR+"^"+SDSTermDR+"^"+SDSValue+"^"+SDSSupplement+"^"+SDSIcdCode+"^"+SDSIcdDesc+"^"+SDSOpenDate+"^"+SDSSequence+"^"+SDSMainDiagFlag
		    	}else{
		    		StructDiagnosResult=StructDiagnosResult+"&"+SDSRowId+"^"+SDSWordDR+"^"+SDSTermDR+"^"+SDSValue+"^"+SDSSupplement+"^"+SDSIcdCode+"^"+SDSIcdDesc+"^"+SDSOpenDate+"^"+SDSSequence+"^"+SDSMainDiagFlag
		    	}
			}
			$.ajax({
				url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.SDSDiagnos&pClassMethod=SaveAll",
				data:{
					"diagStr":StructDiagnosResult,
					"SDSADMDR":mradm,
					"SDSPMIDR":PatientID
				},  
				type:"POST",   
				success: function(data){
					  var data=eval('('+data+')'); 
					  if (data.success == 'true') {
					  		editIndex=undefined;
					  		
							window.top.close();
							//参数:MRDiagRowId_$c(1)_ICDRowId_"^"_MRDiagRowId_$c(1)_ICDRowId
							
							if (data.info!=""){
								window.opener.AfterInsertDiag(data.info);
								window.opener.SaveMRDiagnosToEMR()
								window.opener.UpdateArriveStatus()
							}else{
								window.opener.ReloadDiagEntryGrid();
							}
					  } 
					  else { 
							$.messager.alert('操作提示',"保存失败！","error");
					  }			
				 }  
			})
		}
	}*/
	/******************上移、下移、移到首行开始******************************************/
	//诊断上移按钮
	$("#btnUpDiag").click(function (e) { 
			OrderFunLib("up");
	 })
	 
	 //诊断下移按钮
	$("#btnDownDiag").click(function (e) { 
			OrderFunLib("down");
	 })
	 
	 //诊断移到首行按钮
	$("#btnFirstDiag").click(function (e) { 
			OrderFunLib("first");
	 })
	 //改变上移下移按钮状态
	changeUpDownStatus=function(rowIndex)
	{
			var rows = $('#mygrid').datagrid('getRows');
			var editingRowIndexs=$('#mygrid').datagrid('getEditingRowIndexs')
			//if(rowIndex==0){ 
			if (rowIndex==editingRowIndexs.length){
				$('#btnUpDiag').linkbutton('disable');
				$('#btnFirstDiag').linkbutton('disable');
			}else
			{
				$('#btnUpDiag').linkbutton('enable');
				$('#btnFirstDiag').linkbutton('enable');
			}
			
			
			//if ((rowIndex+1)==(rows.length-editingRowIndexs.length)){
			if (rowIndex==(rows.length-1)){
				$('#btnDownDiag').linkbutton('disable');
			}else
			{
				$('#btnDownDiag').linkbutton('enable');
			}
			
			var row = $('#mygrid').datagrid('getRows')[rowIndex];
			if(row.SDSRowId==undefined){
				$('#btnUpDiag').linkbutton('disable');
				$('#btnDownDiag').linkbutton('disable');
				$('#btnFirstDiag').linkbutton('disable');
			}
	}
	 
	//上移 下移 移到首行
	OrderFunLib=function(type)
	{
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
		var order=""
		var rows = $('#mygrid').datagrid('getRows');	
		var Sequence=parseInt(rows[0].SDSSequence)
		for(var i=0; i<rows.length; i++){	
			var id =rows[i].SDSRowId; //频率id
			if (id==undefined){
				continue;
			}
			var seq=rows[i].SDSSequence;
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
			ClassName:"web.DHCBL.MKB.SDSDiagnos",
			MethodName:"SaveDragOrder",
			order:order,
			seq:Sequence
			},function(txtData){
				$("#mypropertylist").hide();
				$("#myTaglist").hide();
				$("#myDatelist").hide();
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
				var editingRowIndexs=$('#mygrid').datagrid('getEditingRowIndexs')
				var toup = $('#' + gridname).datagrid('getData').rows[index];
				$('#' + gridname).datagrid('insertRow',{
					index:editingRowIndexs.length, // index start with 0
					row: toup
				});
				$('#' + gridname).datagrid('deleteRow', index+1);
				$('#' + gridname).datagrid('selectRow', editingRowIndexs.length); //0
			}	
		}
	}

	/******************上移、下移、移到首行结束******************************************/
	/******************左移、右移开始******************************************/
	//诊断列表左移按钮 
	$("#btnLeftDiag").click(function (e) { 
		MoveFunLib("left")
	 })
	 
	//诊断列表右移按钮 
	$("#btnRightDiag").click(function (e) { 
		MoveFunLib("right")
	 })
	 MoveFunLib=function(direction){
	 	var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		$.ajax({
			url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.SDSDiagnos&pClassMethod=SaveLevel",  
			data:{
				"rowid":record.SDSRowId,
				"direction":direction
			},  
			type:"POST",
			success: function(data){
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
							UpdataRow($("#mygrid").datagrid("getRowIndex",record),data.id)
					 }
					else { 
						$.messager.alert('操作提示',"提交失败！","error");
					}		
			}
		});
	 }
	/******************左移、右移结束******************************************/
    /***************************辅助功能区功能开始***************************************************************************/
    /***************************诊断模板功能开始******************************/
    function LoadTemp(desc){
    	//获取当前选中keywords
    	var keyArray = $('#tempCat').keywords('getSelected');	
		if (keyArray[0].id=="U"){
			$('#tempGrid').datagrid('load',  { 
				ClassName:"web.DHCBL.MKB.SDSDiagnos",
	            QueryName:"GetTempFreqList",
	            LocId:session['LOGON.CTLOCID'],
	            UserId:session['LOGON.USERID'],
	            desc:desc
			});
			$('#tempGrid').datagrid('unselectAll');
		}
		if (keyArray[0].id=="L"){
			$('#tempGrid').datagrid('load',  { 
				ClassName:"web.DHCBL.MKB.SDSDiagnos",
	            QueryName:"GetTempFreqList",
	            LocId:session['LOGON.CTLOCID'],
	            UserId:"",
	            desc:desc
			});
			$('#tempGrid').datagrid('unselectAll');
		}
    	//获取当前选中tab				
		/*var myTab = $('#tempCat').tabs('getSelected');	
		var tabIndex = $('#tempCat').tabs('getTabIndex',myTab);
		if (tabIndex==0){
			$('#tempGrid').datagrid('load',  { 
				ClassName:"web.DHCBL.MKB.SDSDiagnos",
	            QueryName:"GetTempFreqList",
	            LocId:session['LOGON.CTLOCID'],
	            UserId:session['LOGON.USERID'],
	            desc:desc
			});
			$('#tempGrid').datagrid('unselectAll');
		}
		if (tabIndex==1){
			$('#tempGrid').datagrid('load',  { 
				ClassName:"web.DHCBL.MKB.SDSDiagnos",
	            QueryName:"GetTempFreqList",
	            LocId:session['LOGON.CTLOCID'],
	            UserId:"",
	            desc:desc
			});
			$('#tempGrid').datagrid('unselectAll');
		}*/
    }
    //诊断模板检索框定义
	 $('#SearchTemp').searchbox({
		   searcher : function (value, name) { // 在用户按下搜索按钮或回车键的时候调用 searcher 函数
				LoadTemp(value);
		   }
	})
	//检索框实时检索
	var flagTempTime=""
	$('#SearchTemp').searchbox('textbox').unbind('keyup').keyup(function(e){  
			clearTimeout(flagTempTime);
			flagTempTime=setTimeout(function(){
				var desc=$('#SearchTemp').searchbox('textbox').val() 
				LoadTemp(desc);
			},200)
	}); 	
	$('#SearchTemp').searchbox('textbox').bind('click',function(){ 
		$('#SearchTemp').searchbox('textbox').select()    //重新点击时 默认之前输入的值为选中状态，方便删除     
	});
    //模板列表
    var tempGrid = $HUI.datagrid("#tempGrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.MKB.SDSDiagnos",
            QueryName:"GetTempFreqList",
            LocId:session['LOGON.CTLOCID'],
            UserId:session['LOGON.USERID']
        },
        columns: [[
	        {field:'Desc',title:'描述',width:160},
	        {field:'Freq',title:'频次',width:60},
	        {field:'DataReference',title:'诊断id',width:60,hidden:true}
	    ]],  //列信息	
        pagination: false,  
        singleSelect:true,
        remoteSort:false,
        idField:'DataReference',
        fitColumns:true, 
        onDblClickRow: function (rowIndex,rowData) {
        	if(AddData("")==false){
				return;
			}
			editIndex=0 //$('#mygrid').datagrid("getData").total-1
        	checkBeforeSave(rowData.DataReference,"","Term")
	    }
    });
    //诊断模板切换
    $("#tempCat").keywords({
	    singleSelect:true,
	    labelCls:'red',
	    items:[
	        {text:'个人模板',id:'U',selected:true},
	        {text:'科室模板',id:'L'}
	    ],
	    onClick:function(item){
	    	var desc=$('#SearchTemp').searchbox('textbox').val()
			$('#SearchTemp').searchbox('textbox').focus(); 
			if (item.id=="U"){ //个人模板
				$('#tempGrid').datagrid('load',  { 
					ClassName:"web.DHCBL.MKB.SDSDiagnos",
		            QueryName:"GetTempFreqList",
		            LocId:session['LOGON.CTLOCID'],
		            UserId:session['LOGON.USERID'],
		            desc:desc
				});
				$('#tempGrid').datagrid('unselectAll');
			}
			if (item.id=="L"){ //科室模板
				$('#tempGrid').datagrid('load',  { 
					ClassName:"web.DHCBL.MKB.SDSDiagnos",
		            QueryName:"GetTempFreqList",
		            LocId:session['LOGON.CTLOCID'],
		            UserId:"",
		            desc:desc
				});
				$('#tempGrid').datagrid('unselectAll');
			}
	    }
	});
 /*   $('#tempCat').tabs({ 
		onSelect:function(title,index){ 
			var desc=$('#SearchTemp').searchbox('textbox').val()
			$('#SearchTemp').searchbox('textbox').focus(); 
			if (index==0){ //个人模板
				$('#tempGrid').datagrid('load',  { 
					ClassName:"web.DHCBL.MKB.SDSDiagnos",
		            QueryName:"GetTempFreqList",
		            LocId:session['LOGON.CTLOCID'],
		            UserId:session['LOGON.USERID'],
		            desc:desc
				});
				$('#tempGrid').datagrid('unselectAll');
			}
			if (index==1){ //科室模板
				$('#tempGrid').datagrid('load',  { 
					ClassName:"web.DHCBL.MKB.SDSDiagnos",
		            QueryName:"GetTempFreqList",
		            LocId:session['LOGON.CTLOCID'],
		            UserId:"",
		            desc:desc
				});
				$('#tempGrid').datagrid('unselectAll');
			}
		}
    })*/
    /***************************诊断模板功能结束******************************/
    /***************************历史记录功能开始******************************/	
	//清除历史记录明细
	function RemoveLogDetail(){
		for(var i=0;i<100;i++){
			if ($("#detail"+i).length>0){
				$("#date"+i).remove();
				$("#detail"+i).remove();
			}
		}
	}
	// 加载历史记录明细
	function GetLogDetail(SDSRowId,desc){
		var resultLog=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnosLog","GetLog",SDSRowId,desc);
		if (resultLog!=""){
			var list=resultLog.split("*"); 
			var listlen=list.length;
			for(var i=0;i<list.length;i++){
				var content=list[i].split("^")[3]
				var contentlen=1
				if (content.indexOf("&%")>0){
					contentlen=content.split("&%").length;
				}
				var tipcontent=content.replace(/\&%/g, ",")
				tipcontent=tipcontent.replace(/\<a style='color:#FF1493;font-size:16px;'>/g,"")
				tipcontent=tipcontent.replace(/\<a>/g,"")
				content=content.replace(/\&%/g, "</br>") //#40A2DE
				content=content.replace(/\ø/g, "<html><a style='color:#FF6356;font-size:16px;'> ø </a><html/>")
				content=content.replace(/\->/g, "<html><a style='color:#40A2DE;font-size:16px;font-weight: bold;'> → </a><html/>")
				content= '<span class="hisui-tooltip" title="'+tipcontent+'">'+content+'</span>';
				if (i==0){
					$("#log-date").append('<li id="date'+i+'" class="first">'
						+'<div class="date">'+list[i].split("^")[1]+'</div>' 
						+'<div class="time">'+list[i].split("^")[2]+'</div>'
						+'<div class="user">'+list[i].split("^")[0]+'</div>'
						+'</li>')
					$("#log-detail").append('<li id="detail'+i+'" class="first">'
						+'<div class="playcircle" ></div>'
						+'<span class="txt">'+content+'</span>'
						+'</li>')
				}else{
					$("#log-date").append('<li id="date'+i+'" >'
						+'<div class="date">'+list[i].split("^")[1]+'</div>' 
						+'<div class="time">'+list[i].split("^")[2]+'</div>'
						+'<div class="user">'+list[i].split("^")[0]+'</div>'
						+'</li>')
					$("#log-detail").append('<li id="detail'+i+'">'
						+'<div class="node-icon" ></div>'
						+'<span class="txt">'+content+'</span>'
						+'</li>')
				}
				if (contentlen>1){
					var heightLogLi=contentlen*20+20
					$("#date"+i).css("height",""+heightLogLi+"px");
					$("#detail"+i).css("height",""+heightLogLi+"px");
				}else{
					$("#date"+i).css("height","60px");
					$("#detail"+i).css("height","60px");
				}
			}
		}
	}
	//修改历史检索框定义
	 $('#SearchLog').searchbox({
		   searcher : function (value, name) { // 在用户按下搜索按钮或回车键的时候调用 searcher 函数
				RemoveLogDetail();
				var record=$('#mygrid').datagrid('getSelected');
				if (record){
					GetLogDetail(record.SDSRowId,value)
				}
		   }
	})
	//修改历史检索框实时检索
	var flagLogTime=""
	$('#SearchLog').searchbox('textbox').unbind('keyup').keyup(function(e){  
			clearTimeout(flagLogTime);
			flagLogTime=setTimeout(function(){
				var desc=$('#SearchLog').searchbox('textbox').val() 
				RemoveLogDetail();
				var record=$('#mygrid').datagrid('getSelected');
				if (record){
					GetLogDetail(record.SDSRowId,desc)
				}
			},200)
	}); 	
	$('#SearchLog').searchbox('textbox').bind('click',function(){ 
		$('#SearchLog').searchbox('textbox').select()    //重新点击时 默认之前输入的值为选中状态，方便删除     
	});
	/***************************历史记录功能结束*********************************/
	$('#myTabs').tabs({ 
		onSelect:function(title,index){ 
			if (title=="诊断模板"){
				$('#SearchTemp').searchbox('setValue','')
				$('#SearchTemp').searchbox('textbox').focus(); 
			}
			if (title=="智能提示"){
				var row = $('#mygrid').datagrid('getSelected');
				if (row){
					if (row.SDSTermDR==undefined){ //未保存诊断
						var rowIndex=$("#mygrid").datagrid("getRowIndex",row);
						var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+rowIndex+']');
						var SDSTermDR=$(col).find('td[field=SDSTermDR] input').val()
						if (SDSTermDR!=""){
			    			var SDSIcdCode=$(col).find('td[field=SDSIcdCode] span').html()
		    				var SDSIcdDesc=$(col).find('td[field=SDSIcdDesc] input').val()
			    			var SDSValue=$(col).find('td[field=SDSValue] input').val()
			    			InitSmartTip(SDSTermDR,"init",SDSIcdCode+"^"+SDSIcdDesc,SDSValue)
						}else{
							RemoveSmartTip();
						}
					}else{ //已保存诊断
						InitSmartTip(row.SDSTermDR,"init",row.SDSIcdCode+"^"+row.SDSIcdDesc,"")
					}
				}
			}
	     	if (title=="修改历史"){ //修改历史功能
				$('#SearchLog').searchbox('setValue','')
				$('#SearchLog').searchbox('textbox').focus();
				var row = $('#mygrid').datagrid('getSelected');
				if (row){
					GetLogDetail(row.SDSRowId,"")
				}
	     	}
	    },
	    onUnselect:function(title,index){
	    	if (title=="诊断模板"){
				
			}
	    	if (title=="智能提示"){
	    		RemoveSmartTip()
	    	}
	    	if (title=="修改历史"){
	    		RemoveLogDetail()
	    	}
	    }
	})
	
	$("#btnAssistModel").addClass("x-btn-click") //默认选中诊断模板
	function RemoveClass(){
		$("#btnAssistModel").removeClass("x-btn-click")
		$("#btnAssistTip").removeClass("x-btn-click")
		$("#btnAssistLog").removeClass("x-btn-click")
	}
	$("#btnAssistModel").click(function (e) { 
		RemoveClass()
		$("#btnAssistModel").addClass("x-btn-click")
		$('#myTabs').tabs('select',"诊断模板"); 
	})
	$("#btnAssistTip").click(function (e) { 
		RemoveClass()
		$("#btnAssistTip").addClass("x-btn-click")
		$('#myTabs').tabs('select',"智能提示"); 
	})
	$("#btnAssistLog").click(function (e) { 
		RemoveClass()
		$("#btnAssistLog").addClass("x-btn-click")
		$('#myTabs').tabs('select',"修改历史"); 
	})
	/***************************辅助功能区功能结束***************************************************************************/
	/*
	*  datagrid 获取正在编辑状态的行，使用如下：
	*  $('#id').datagrid('getEditingRowIndexs'); //获取当前datagrid中在编辑状态的行编号列表
	*/
	$.extend($.fn.datagrid.methods, {
	    getEditingRowIndexs: function(jq) {
	        var rows = $.data(jq[0], "datagrid").panel.find('.datagrid-row-editing');
	        var indexs = [];
	        rows.each(function(i, row) {
	            var index = row.sectionRowIndex;
	            if (indexs.indexOf(index) == -1) {
	                indexs.push(index);
	            }
	        });
	        return indexs;
	    },
	    getSelectedRowIndexs: function(jq) {
	        var rows = $.data(jq[0], "datagrid").panel.find('.datagrid-row-selected');
	        var indexs = [];
	        rows.each(function(i, row) {
	            var index = row.sectionRowIndex;
	            if (indexs.indexOf(index) == -1) {
	                indexs.push(index);
	            }
	        });
	        return indexs;
	    }
	});
}
$(init);
