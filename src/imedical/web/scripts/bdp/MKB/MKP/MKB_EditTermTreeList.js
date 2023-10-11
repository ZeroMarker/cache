/// 名称: 医用知识库 -树型、列表型可编辑术语
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-丁亚男
/// 编写日期: 2019-02-20

var init = function(){

	var HISUI_SQLTableName="MKB_Term",HISUI_ClassTableName="User.MKBTerm"+base;
	
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=DeleteData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=SaveData&pEntityName=web.Entity.MKB.MKBTerm";
	//var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetList";
	if (basetype=="T")
	{
		var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetTreeJsonListForPages";	
	}
	else
	{
		var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetMyList";
	}
	//配置展示在左侧列表的公有属性列
	var extendInfo=tkMakeServerCall('web.DHCBL.MKB.MKBTerm','GetShowInLeftInfo',base);
	var extend=extendInfo.split("[A]")
	var extendChild =extend[0];  //配置展示在左侧的注册属性id串
	var extendTitle =extend[1];  //配置展示在左侧的注册属性名称
	
	var editIndex = undefined;  //正在编辑的行index
	var rowsvalue=undefined;   //正在编辑的行数据
	var oldrowsvalue=undefined;  //上一个编辑的行数据
	var preeditIndex="";     //上一个编辑的行index
    var columns =[[  
					 {field:'MKBTRowId',title:'RowId',width:80,sortable:true,hidden:true},
					 {field:'MKBTDesc',title:'中心词',width:100,sortable:true,editor:'validatebox'},
					 {field:'MKBTSequence',title:'顺序',width:80,sortable:true,/*sorter:function (a,b){  
						    if(a.length > b.length) return 1;
						        else if(a.length < b.length) return -1;
						        else if(a > b) return 1;
						        else return -1;
					},*/editor:'validatebox'},
					 {field:'MKBTPYCode',title:'检索码',width:80,editor:'validatebox'},
					 {field:'MKBTLastLevelF',title:'上级节点ID',width:80,sortable:false,editor:'validatebox',hidden:true},
					 {field:'MKBTLastLevel',title:'上级节点',width:100,sortable:false,hidden:basetype=="L"?true:false,
						 editor:{
							type:'combotree',
							options:{
								panelWidth:200,
								onShowPanel:function(){		
									var opts = $(this).combotree('options')
									var url="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmb&base="+base
					         		if (opts)
					         		{
					         			$(this).combotree('reload',url);
					         		}
		
					         	},
								onHidePanel:function(){
					         		var target=$(this)
									setTimeout(function(){
										//var val=target.next().find('.combo-text').val();
										var val=target.combotree('getText');
						        		var ed = $('#mygrid').datagrid('getEditor', {index:editIndex,field:'MKBTLastLevelF'});
										$(ed.target).val(val)
									},100)
										
									
									if($(this).combo('getText')==""){
										$(this).combo('setValue',"")
									}
								}
							}
						}},
					 {field:'MKBTNote',title:'备注',width:200,editor:{type:'textarea'},
						formatter:function(value,row,index){  
							//鼠标悬浮显示备注信息
							return '<span class="mytooltip" title="'+row.MKBTNote+'">'+value+'</span>'
						}}
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
				column["hidden"]=false; 
				columns[0].push(column)
			
			}
		}
	
	///列表datagrid
	var mygrid = $HUI.datagrid("#mygrid",{
		url:QUERY_ACTION_URL+"&base="+base+"&rowid="+SelectTermID+"&desc="+MainDesc,
		columns:columns,
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:20,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		idField:'MKBTRowId', 
		toolbar:'#mytbar',
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:true,  //定义是否从服务器排序数据。true
		//sortName : 'MKBTSequence',
		//sortOrder : 'asc', 
		ClassTableName:HISUI_ClassTableName,
		SQLTableName:HISUI_SQLTableName,
		onClickRow:function(rowIndex,rowData){
			$('mygrid').datagrid('selectRow', rowIndex);
			//树形列表在左侧定位定位
			if (basetype=="T")
			{
				window.parent.LocationALL(rowData.MKBTRowId)
			}
			else
			{
				//改变上移下移按钮状态
				changeUpDownStatus(rowIndex);
			}
			ClickFun();
			//保存历史和频次记录
			RefreshSearchData(HISUI_ClassTableName+base,rowData.MKBTRowId,"A",rowData.MKBTDesc)
		},
		onDblClickRow:function(rowIndex,rowData){
			$('.mytooltip').tooltip('hide');
			//双击事件
			DblClickFun(rowIndex,rowData)
			if(basetype=="L")
			{
				//改变上移下移按钮状态
				changeUpDownStatus(rowIndex);
			}
		},
		
		onLoadSuccess:function(data){
			$('.mytooltip').each(function(){
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
		    })
        	$(this).datagrid('columnMoving');			
		}
	});
	
	//用于单击非grid行保存可编辑行
	$(document).bind('click',function(){ 
	    ClickFun()
	}); 
	//用户习惯
	//ShowUserHabit('mygrid');
	
	 //类百度查询框
	$('#TextDesc').searchcombobox({ 
		url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+HISUI_ClassTableName
	});
	
	$('#TextDesc').combobox('textbox').bind('keyup',function(e){ 
		if (e.keyCode==13){ 
			SearchFunLib() 
		}
    }); 
	//查询框赋初值
	if (MainDesc!="")
	{
		$("#TextDesc").combobox('setValue', MainDesc);
	}
	
    $("#btnSearch").click(function (e) { 
		SearchFunLib();
	})  
	
	
	///重置按钮
	$("#btnRefresh").click(function (e) { 
		ClearFunLib();
	 }) 
 
	///添加按钮
	$("#add_btn").click(function (e) { 
		AddData();
	}) 
	
	///保存按钮
	$("#save_btn").click(function (e) { 
		SaveFunLib();
	}) 
	
	///删除按钮
	$("#del_btn").click(function (e) { 
		DelData();
	})  
	
	

	$('.datagrid-pager').find('a').each(function(){
		$(this).click(function(){
			editIndex = undefined;
			rowsvalue=undefined;
			oldrowsvalue=undefined;
			preeditIndex="";
		})
	})
	
	
	
	//加载表达式、多行文本框等可编辑表格控件
	function AppendDom(){
		if (editIndex!=undefined)
		{
			var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+editIndex+']')[1];
			$(col).find('table').each(function(){
				var target=$(this).find('input:first')
				if(target.css('display')=='none'){
					target.next().find('input:first').click(function(){
						
					})
				}
				else{
					target.click(function(){
						
					})
				}
			})
			//备注多行文本框
			CreateTADom(col,"MKBTNote")	
			
			//展示名和拼音码赋值
			var descTarget=$(col).find('td[field=MKBTDesc] input')
			if (mygrid.getRows()[editIndex].MKBTRowId==undefined) 
			{
				
				descTarget.keyup(function(){	
					var desc=descTarget.val()  //中心词列的值
					//检索码赋值
					var PYCode=Pinyin.GetJPU(desc)
					var PYCodeCol=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"MKBTPYCode"});							
					$(PYCodeCol.target).val(PYCode)					
				})
			}
			descTarget.click(function(){
				var desc=descTarget.val()  //中心词列的值
			
				//检索码赋值
				var PYCode=Pinyin.GetJPU(desc)
				var PYCodeCol=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"MKBTPYCode"});	
				if ((mygrid.getRows()[editIndex].MKBTPDRowId==undefined)||(PYCodeCol.target.val()==""))
				{
					$(PYCodeCol.target).val(PYCode)
				}
				
			})		
			
		}
	} 

	
	//修改完后给这一行赋值
	function UpdataRow(row,Index){
		if (basetype=="T")
		{
			//上级分类
			temp=row.MKBTLastLevel
			row.MKBTLastLevel=row.MKBTLastLevelF
			row.MKBTLastLevelF=temp
		}
		//备注
		row.MKBTNote=row.MKBTNote.replace(/<br\/>/g,"\n"); 
		$('#mygrid').datagrid('updateRow',{
			index: Index,
			row:row
		})
		$('.mytooltip').each(function(){
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
		    })
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
			if(rowsvalue!= undefined){
				if((rowsvalue.MKBTDesc!="")){
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
					$.messager.alert('错误提示','中心词不能为空!',"error");
					$('#mygrid').datagrid('selectRow', editIndex)
						.datagrid('beginEdit', editIndex);
					AppendDom()
					return
				}
			}

		}
	}

	
	//grid双击事件
	function DblClickFun (index,row,field){   //双击激活可编辑   （可精简）		
		if(index==editIndex){
			return
		}
		if((row!=undefined)&&(row.MKBTRowId!=undefined)){
			UpdataRow(row,index)
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
		AppendDom(field)
		
		if (basetype=="T")
		{
			//引用下拉框
			var ed =  $('#mygrid').treegrid("getEditor",{index:index,field:"MKBTLastLevel"});
			var idF =row.MKBTLastLevel
			if ((idF!="")&(idF!=undefined)){
				var url="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmbDesc&base="+base+"&id="+idF
				$(ed.target).combotree('reload',url);
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
		if((rowsvalue.MKBTDesc=="")){
			$.messager.alert('错误提示','中心词不能为空!',"error");
			$('#mygrid').datagrid('selectRow', editIndex)
				.datagrid('beginEdit', editIndex);
			AppendDom()
			return		
		}
		record.MKBTBaseDR=base
		//执行保存
		$.ajax({
			type: 'post',
			url: SAVE_ACTION_URL,
			data: record,
			success: function (data) { //返回json结果			
				var data=eval('('+data+')');
				if(data.success=='true'){
				  $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				  if(basetype=="T")
				  {
				  	window.parent.RefreshParent(record.MKBTLastLevel,record.MKBTRowId)
				  }
				 
				  if(saveType=='AddData'){
				      preeditIndex=preeditIndex+1;
				  }
				  //alert(saveType+"&"+preeditIndex)
				  record.MKBTRowId=data.id
				  UpdataRow(record,preeditIndex);
				  if(saveType!='AddData'){
						editIndex=undefined
						rowsvalue=undefined
					}
				}
				else{
					var errorMsg="保存失败！";
					if(data.errorinfo){
						errorMsg=errorMsg+'</br>错误信息:'+data.errorinfo
					}
					$.messager.alert('错误提示',errorMsg,'error',function(){
						UpdataRow(record,preeditIndex)
			       		editIndex=undefined
			       		DblClickFun (preeditIndex,record);
			        })
			   }
			}
		});
		
	}
	
	 ///查询方法
	SearchFunLib=function()
	{
		//var desc=$.trim($('#TextDesc').searchbox('getValue'));
		var desc=$("#TextDesc").combobox('getText')
		if (basetype=="T")
		{
			queryname="GetTreeJsonListForPages"
		}
		else
		{
			queryname="GetMyList"
		}
		$('#mygrid').datagrid('load',  {
			ClassName:"web.DHCBL.MKB.MKBTerm",         ///调用Query时
			QueryName:queryname,
			'base':base,
			'rowid':"",
			'desc':desc
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	///重置方法
	ClearFunLib=function()
	{
		editIndex = undefined;  //正在编辑的行index
		rowsvalue=undefined;   //正在编辑的行数据
		if (basetype=="T")
		{
			queryname="GetTreeJsonListForPages"
		}
		else
		{
			queryname="GetMyList"
		}
		//$("#TextDesc").searchbox('setValue', '');
		$("#TextDesc").combobox('setValue', '');
		
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.MKB.MKBTerm",         ///调用Query时
			QueryName:queryname,
			'base':base,
			'rowid':"",
			'desc':""
			
		});
		$('#mygrid').datagrid('unselectAll');
		if (basetype=="T")
		{
			//父界面重置
			window.parent.ClearFunLibTree()
		}
		else
		{
			//上移下移按钮改为可用
			$('#btnUp').linkbutton('enable');
			$('#btnDown').linkbutton('enable');
			$('#btnFirst').linkbutton('enable');
			//父界面重置
			window.parent.ClearFunLib()
		}
	}
	
	///删除
	DelData=function()
	{        
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		if((record.MKBTRowId==undefined)||(record.MKBTRowId=="")){
			mygrid.deleteRow(editIndex)
			editIndex = undefined;
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
							  	    if (basetype=="T")
							  	    {
							  	    	$(window.parent.$("#mygrid").treegrid('remove',record.MKBTRowId));
							  	    }
							  	    //保存历史和频次记录
									RefreshSearchData("User.MKBTerm"+base,record.MKBTRowId,"D","")
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
				})
			}
		});
	}
	
	
	
	
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
	if(basetype=="T")
	{
		document.getElementById("btnUp").style.display = "none"; //隐藏上移
		document.getElementById("btnDown").style.display = "none"; //隐藏下移
		document.getElementById("btnFirst").style.display = "none"; //隐藏移动到首行
	}
	else
	{
		document.getElementById("btnUp").style.display = ""; //展示上移
		document.getElementById("btnDown").style.display = ""; //展示下移
		document.getElementById("btnFirst").style.display = ""; //展示移动到首行
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
			
			//保存拖拽后的顺序
			$.m({
				ClassName:"web.DHCBL.MKB.MKBTerm",
				MethodName:"SaveDragOrder",
				order:order,
				seq:Sequence
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
	}
	
	
};
$(init);
