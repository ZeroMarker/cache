
var init = function()
{
	var locbaseID=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","getTermId","LOC");//专业科室id
	var partbasedr=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetIdByFlag","Part")
	var disbasedr=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetIdByFlag","Pathogeny")
	if(baseType == "part")
	{
		var queryname="GetDiagByPart"
	}
	else if(baseType == "dis")
	{
		var queryname="GetDiagByDis"
	}
	else
	{
		var queryname=""
	}
	var editIndex = undefined;  //正在编辑的行index
	var rowsvalue=undefined;   //正在编辑的行数据
	var oldrowsvalue=undefined;  //上一个编辑的行数据
	var preeditIndex="";     //上一个编辑的行index
	//中心词界面
	var termcolumns =[[
		{field:'ck',checkbox:true},
	    {field:'MKBTRowId',title:'MKBTRowId',width:80,hidden:true},
	    {field:'MKBTDesc',title:'中心词',width:110},
	    {field:'MKBPartDescF',title:'部位ID',width:80,sortable:false,editor:'validatebox',hidden:true},
	    {field:'MKBPartDesc',title:'部位',width:110,
	        editor : {
	                 type:'combotree',
	                 options:{
								panelWidth:200,
								onShowPanel:function(){		
									var opts = $(this).combotree('options')
									var url="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmb&base="+partbasedr
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
						        		var ed =$('#termgrid').datagrid('getEditor', {index:editIndex,field:'MKBPartDescF'});
										$(ed.target).val(val)
									},100)
										
									
									if($(this).combo('getText')==""){
										$(this).combo('setValue',"")
									}
								}
	                 }
					 
		   }
	    },
	    {field:'MKBDisDescF',title:'病因ID',width:80,sortable:false,editor:'validatebox',hidden:true},
	    {field:'MKBDisDesc',title:'病因',width:110,
	        editor : {
	                 type:'combotree',
	                 options:{
								panelWidth:200,
								onShowPanel:function(){		
									var opts = $(this).combotree('options')
									var url="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmb&base="+disbasedr
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
						        		var ed = $('#termgrid').datagrid('getEditor', {index:editIndex,field:'MKBDisDescF'});
										$(ed.target).val(val)
									},100)
										
									
									if($(this).combo('getText')==""){
										$(this).combo('setValue',"")
									}
								}
	                 }
		   }
	    },
	    {field:'MKByn',title:'是否处理',width:40,align:'center',
	    	formatter:function(value,row,index){
	        	//var flag = tkMakeServerCall("web.DHCBL.MKB.MKBAssInterface","justTermExist",row.MKBTRowId);	
	        	if(value == 1){
					 var content = '已处理';	
		        }
		        else if(value == 0){
			        var content = '未处理';
			    }else if(value == 2){
			        var content = '放弃';					    
				}
				return content;
			    		        		
	        },
	        styler: function(value,row,index){
	        	if(value == 1){
					 return 'background-color:#2ab66a;color:white;';	
		        }
		        else if(value == 0){
			        return 'background-color:#ffb746;color:white;';
			    }else if(value == 2){
			        return 'background-color:#f16e57;color:white;';					    
				}
			}

	    }
	]];
	var termgrid = $HUI.datagrid("#termgrid",{
	    url:$URL,
	    queryParams:{
	        ClassName:"web.DHCBL.MKB.MKBAssInterface",
	        QueryName:queryname,
	        PartId:termid
	    },
	    width:'100%',
	    height:'100%',
	    //url:TERM_ACTION_URL,
	    columns: termcolumns,  //列信息
	    pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
	    pageSize:100,
	    pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
	    //sortName:'MKBTSequence',
	    //sortOrder:'asc',
	    remoteSort:false,  //定义是否从服务器排序数据。true
	    //singleSelect:false,
	    singleSelect:true,
		checkOnSelect:false,
		selectOnCheck:false,
	    idField:'MKBTRowId',
	    rownumbers:false,    //设置为 true，则显示带有行号的列。
	    fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
	    fit:true,
	    //remoteSort:false,  //定义是否从服务器排序数据。true
	    //scrollbarSize :0,
	    onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);

	    },
	    onCheck:function(index,row)
	    {
	        /*var flag = tkMakeServerCall("web.DHCBL.MKB.MKBAssInterface","justTermExist",row.MKBTRowId);
	        if(flag == 1)
	        {
		        alert("数据已经处理过！")
		        $("#termgrid").datagrid("uncheckRow",index);
		        //$("#termgrid").datagrid("unselectRow",index);
		    }*/
	    },
	    onClickRow:function(index,row){
	    	$('termgrid').datagrid('selectRow', index);
			ClickFun();
		},
		onDblClickRow:function(index,row){
			//双击事件
			DblClickFun(index,row)
		},
		 onRowContextMenu:function (e, rowIndex,row) { //右键时触发事件
            e.preventDefault();//阻止浏览器捕获右键事件
            $(this).datagrid('selectRow', rowIndex);
            var mygridmm = $('<div style="width:150px;"></div>').appendTo('body');
            $(
				'<div onclick="dealPart()" iconCls="icon-paste" data-options="">批处理部位</div>'+
				'<div onclick="Pathogeny()" iconCls="icon-paper" data-options="">批处理病因</div>'			
            ).appendTo(mygridmm)
            mygridmm.menu()
            mygridmm.menu('show',{
                left:e.pageX,
                top:e.pageY
            });
		 }
	});
	//批量处理部位
	dealPart = function(){
		var Checkedrecord =  $('#termgrid').datagrid('getChecked')
		var Selectedrecord = $('#termgrid').datagrid('getSelected')
		if (!(Selectedrecord)) {
			$.messager.alert('提示','请选择批处理部位的知识!',"warning");
			return;
		} 
		if (!(Checkedrecord)) {
			$.messager.alert('提示','请选择需要批处理部位的知识!',"warning");
			return;
		} 
		
		var SelectedRowId = Selectedrecord.MKBTRowId
		var CheckedRowId=""
		for(var i = 0; i < Checkedrecord.length; i++){
			if (CheckedRowId=="")
			{
				CheckedRowId=Checkedrecord[i].MKBTRowId
			}
			else
			{
				CheckedRowId=CheckedRowId+","+Checkedrecord[i].MKBTRowId
			}
			
		}
		var result=tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","DealPartProperty",SelectedRowId,CheckedRowId);
		var data=eval('('+result+')');
		if(data.success=='true'){  
			$.messager.popover({msg: '批处理成功!',type:'success',timeout: 1000});
			$('#termgrid').datagrid('reload');
		}else{
			var errorMsg="处理失败！";
			if(data.errorinfo){
				errorMsg=errorMsg+'</br>错误信息:'+data.errorinfo
			}
			$.messager.alert('错误提示',errorMsg,'error')
		}		
	}
	//批量处理病因
	Pathogeny = function(){
		var Checkedrecord =  $('#termgrid').datagrid('getChecked')
		var Selectedrecord = $('#termgrid').datagrid('getSelected')
		if (!(Selectedrecord)) {
			$.messager.alert('提示','请选择批处理病因的知识!',"warning");
			return;
		} 
		if (!(Checkedrecord)) {
			$.messager.alert('提示','请选择需要批处理病因的知识!',"warning");
			return;
		} 
		
		var SelectedRowId = Selectedrecord.MKBTRowId
		var CheckedRowId=""
		for(var i = 0; i < Checkedrecord.length; i++){
			if (CheckedRowId=="")
			{
				CheckedRowId=Checkedrecord[i].MKBTRowId
			}
			else
			{
				CheckedRowId=CheckedRowId+","+Checkedrecord[i].MKBTRowId
			}
			
		}
		var result=tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","DealPathogenyProperty",SelectedRowId,CheckedRowId);
		var data=eval('('+result+')');
		if(data.success=='true'){  
			$.messager.popover({msg: '批处理成功!',type:'success',timeout: 1000});
			$('#termgrid').datagrid('reload');
		}else{
			var errorMsg="处理失败！";
			if(data.errorinfo){
				errorMsg=errorMsg+'</br>错误信息:'+data.errorinfo
			}
			$.messager.alert('错误提示',errorMsg,'error')
		}		
	}
	
	
	//是否处理下拉框
	$("#TextYN").combobox({
	    valueField:'id',
	    textField:'text',
	    data:[
	        {id:'1',text:'已处理'},
	        {id:'0',text:'未处理'},
	        {id:'2',text:'放弃'}
	    ],
	    panelHeight:100,
	    onSelect: function(record){
			searchFunLib();
	    }
			
	})


	//点击查询按钮
	/*$('#btnSearch').click(function(e){
			searchFunLib();
	})*/
	$("#TextDesc").keyup(function(){
     	searchFunLib();
    });
    //检索框单击选中输入内容
	$('#TextDesc').bind('click',function(){
		$('#TextDesc').select()         
	});
	//查询方法
	searchFunLib=function(){
		var deal=$('#TextYN').combobox('getValue')
		var desc=$('#TextDesc').val()
	    $('#termgrid').datagrid('reload',  {
	        ClassName:"web.DHCBL.MKB.MKBAssInterface",
	        QueryName:queryname,
	        PartId:termid,
	        desc:desc,
	        deal:deal
	    });	
	    $("#termgrid").datagrid('unselectAll');	
	}	
	//批量添加按钮
	$('#btnAddAll').click(function(e){
		var data = $('#termgrid').datagrid('getChecked');
		//alert(data[1].MKBTRowId)
		if(data == "" || data == null){
			alert("请至少选中一条数据！");
			return;
		}else{
			var termIds="";
			for(var i = 0;i < data.length; i++){
				if(termIds == ""){
					termIds = data[i].MKBTRowId;	
				}else{
					termIds=termIds+"^"+data[i].MKBTRowId;				
				}	
			}
			//alert(termIds);
			//tkMakeServerCall("web.DHCBL.MKB.MKBAssInterface","putIdIntoGloble",termIds);//存到临时globle里	
			parent.UpdateDiaTemplate(termIds,termid);
			//$('#termgrid').datagrid('reload');
			//$('#termgrid').datagrid('unselectAll');
		}
	})
	//点击放弃按钮
	$('#btnCancel').click(function(e){
		var data = $('#termgrid').datagrid('getChecked');
		//alert(data[1].MKBTRowId)
		if(data == "" || data == null){
			alert("请至少选中一条数据！");
			return;
		}else{
			var termIds="";
			for(var i = 0;i < data.length; i++){
				if(termIds == ""){
					termIds = data[i].MKBTRowId;	
				}else{
					termIds=termIds+"^"+data[i].MKBTRowId;				
				}	
			}
			tkMakeServerCall("web.DHCBL.MKB.MKBAssInterface","giveUpManage",termIds);
			$('#termgrid').datagrid('reload');
			$('#termgrid').datagrid('unselectAll');		
		}	

	})	
	//点击已处理按钮
	$('#hasDelBtn').click(function(e){
		var data = $('#termgrid').datagrid('getChecked');
		//alert(data[1].MKBTRowId)
		if(data == "" || data == null){
			alert("请至少选中一条数据！");
			return;
		}else{
			var termIds="";
			for(var i = 0;i < data.length; i++){
				if(termIds == ""){
					termIds = data[i].MKBTRowId;	
				}else{
					termIds=termIds+"^"+data[i].MKBTRowId;				
				}	
			}
			tkMakeServerCall("web.DHCBL.MKB.MKBAssInterface","putIdIntoGloble",termIds);
			$('#termgrid').datagrid('reload');
			$('#termgrid').datagrid('unselectAll');		
		}	

	})
	//点击未处理按钮
	$('#noDelBtn').click(function(e){
		var data = $('#termgrid').datagrid('getChecked');
		//alert(data[1].MKBTRowId)
		if(data == "" || data == null){
			alert("请至少选中一条数据！");
			return;
		}else{
			var termIds="";
			for(var i = 0;i < data.length; i++){
				if(termIds == ""){
					termIds = data[i].MKBTRowId;	
				}else{
					termIds=termIds+"^"+data[i].MKBTRowId;				
				}	
			}
			tkMakeServerCall("web.DHCBL.MKB.MKBAssInterface","delIdFromGloble",termIds);
			$('#termgrid').datagrid('reload');
			$('#termgrid').datagrid('unselectAll');		
		}	

	})
	$('.datagrid-pager').find('a').each(function(){
		$(this).click(function(){
			editIndex = undefined;
			rowsvalue=undefined;
			oldrowsvalue=undefined;
			preeditIndex="";
		})
	})
	
	//用于单击非grid行保存可编辑行
	$(document).bind('click',function(){ 
	    ClickFun()
	});
	//修改完后给这一行赋值
	function UpdataRow(row,Index){
		//部位
		temp=row.MKBPartDesc
		row.MKBPartDesc=row.MKBPartDescF
		row.MKBPartDescF=temp
		//病因
		temp=row.MKBDisDesc
		row.MKBDisDesc=row.MKBDisDescF
		row.MKBDisDescF=temp
		
		$('#termgrid').datagrid('updateRow',{
			index: Index,
			row:row
		})
	}
	//是否有正在编辑的行true/false
	function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#termgrid').datagrid('validateRow', editIndex)){
			$('#termgrid').datagrid('endEdit', editIndex);
			rowsvalue=termgrid.getRows()[editIndex];
			//editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}  
	//grid单击事件
	function ClickFun(){   //单击执行保存可编辑行
		if (endEditing()){
			if(rowsvalue!= undefined){
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
						SaveData(rowsvalue);
					}
					else{
						UpdataRow(rowsvalue,editIndex)
						editIndex=undefined
						rowsvalue=undefined
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
				$('#termgrid').datagrid('selectRow', index)
						.datagrid('beginEdit', index);
				editIndex = index;
			} else {
				$('#termgrid').datagrid('selectRow', editIndex);
			}
		}
		oldrowsvalue=JSON.stringify(row);   //用于和rowvalue比较 以判断是否行值发生改变
		
		//部位下拉框
		var ed =  $('#termgrid').datagrid("getEditor",{index:index,field:"MKBPartDesc"});
		var idF =row.MKBPartDesc
		if ((idF!="")&(idF!=undefined)){
			var url="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmbDesc&base="+partbasedr+"&id="+idF
			$(ed.target).combotree('reload',url);
		}
		//病因下拉框
		var ed =  $('#termgrid').datagrid("getEditor",{index:index,field:"MKBDisDesc"});
		var iddisF =row.MKBDisDesc
		if ((iddisF!="")&(iddisF!=undefined)){
			var url="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmbDesc&base="+disbasedr+"&id="+iddisF
			$(ed.target).combotree('reload',url);
		}
	}
	///保存方法
	function SaveData(record){
		$.m({
					ClassName:"web.DHCBL.MKB.MKBTermProperty",
					MethodName:"UpdatePartDisProperty",
					MKBTRowId:record.MKBTRowId,
					MKBPartDesc:record.MKBPartDesc,	
					MKBDisDesc:record.MKBDisDesc
				},function (data) { 
					  var data=eval('('+data+')'); 
					  if (data.success == 'true') {
					  		$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
					  		editIndex=undefined
							rowsvalue=undefined
					  		//record.MKBTRowId=data.id
				  			UpdataRow(record,preeditIndex);
							//$('#termgrid').datagrid('reload');  // 重新载入当前页面数据
					  } 
					  else { 
							var errorMsg ="提交失败！"
							if (data.errorinfo) {
								errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
							}
							$.messager.alert('操作提示',errorMsg,"error",function(){
								UpdataRow(record,preeditIndex)
					       		editIndex=undefined
					       		DblClickFun (preeditIndex,record);
					        });
					}
			}); 
		
	}
	/***********************************************专业科室功能开始********************************************* */
	//点击专业科室按钮
	$('#pro_loc_btn').click(function(e){
		addCheckedRowId=""
		var records = $('#termgrid').datagrid('getChecked')
		if(records=="")
		{
			$.messager.alert('操作提示',"请先在列表勾选至少一条数据！","error");
			return
		}
		var t = $('#proloc_div')
		t.css({
				"top": 30,
				"left": 300
			}).show();
		
		/*if(e.originalEvent.clientY+$("#layout").height()+30>$(window).height())
		{
			t.css({
				"top": e.originalEvent.clientY-t.height()-5,
				"left": e.originalEvent.clientX-300
			}).show();
		}
		else{
			t.css({
				"top": e.originalEvent.clientY+30,
				"left": e.originalEvent.clientX-300
			}).show();
		}*/
		for(var i = 0; i < records.length; i++){
			if (addCheckedRowId=="")
			{
				addCheckedRowId=records[i].MKBTRowId
			}
			else
			{
				addCheckedRowId=addCheckedRowId+","+records[i].MKBTRowId
			}
			
		}	
	})
	//科室列表
	$HUI.tree('#catTree',{
		url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBStructuredData&pClassMethod=GetTreeJson&base="+locbaseID,
		lines:true,  //树节点之间显示线条
		autoSizeColumn:false,
		checkbox:true,
		cascadeCheck:false,  //是否级联检查。默认true  菜单特殊，不级联操作		
		animate:false,   //是否树展开折叠的动画效果
		id:'id',//这里的id其实是所选行的idField列的值
		onLoadSuccess:function(data){
			//$("#FindTreeText").val("")
			$('#FindTreeText').searchbox('setValue',""); 
			$HUI.radio("#myChecktreeFilterCK0").setValue(true)  //初始设置为全部

		},
		onBeforeExpand:function(node){
			$(this).tree('expandFirstChildNodes',node)
        },
		onContextMenu: function(e, node){
			$('#catTree').tree('select', node.target);
			$('#catTree').tree('check', node.target);
		
		}
			
	});
	//专业科室点击关闭按钮
	$('#locClose_btn').click(function(e){
		ClearFunLibProLoc()
		$('#proloc_div').hide();
	})
	//专业科室重置按钮
	$("#locRefresh_btn").click(function (e) { 
		ClearFunLibProLoc();
	})
	ClearFunLibProLoc = function(){
		//$("#FindTreeText").val("")
		$('#FindTreeText').searchbox('setValue',""); 
		$HUI.radio("#myChecktreeFilterCK0").setValue(true)  //初始设置为全部
		$("#catTree").tree('reload');  // 重新载入当前页面数据reload();
		treeChecked("unchecked", "catTree")
		
	} 
	//专业科室添加按钮
	$("#locSave_btn").click(function (e) { 
		SaveFunLibProLoc();
	}) 
	var addIds=""  //要添加专业科室的id串
	var addCheckedRowId="" //要添加诊断的id串
	SaveFunLibProLoc = function(){
		addIds=""  //要添加的数据		
		var nodes = $('#catTree').tree('getChecked', ['checked','indeterminate']);  //获取选中及不确定的节点
		/*if(nodes.length==0){
			$.messager.alert('错误提示','请至少选择一条科室!',"error");
        	return;		
		}*/	
		//获取要添加到属性内容表的术语
		for (var i = 0; i < nodes.length; i++) {
			if (addIds!=""){
				addIds=addIds+","+nodes[i].id
			}
			else{
				addIds=nodes[i].id
			}				
		}
		if(addIds!="")
		{
			var result=tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","DealProLocDia",addCheckedRowId,addIds);
			var data=eval('('+result+')');
			if(data.success=='true'){  
				$.messager.popover({msg: '保存成功!',type:'success',timeout: 1000});
				$('#termgrid').datagrid('reload');
			}else{
				var errorMsg="保存失败！";
				if(data.errorinfo){
					errorMsg=errorMsg+'</br>错误信息:'+data.errorinfo
				}
				$.messager.alert('错误提示',errorMsg,'error')
			}
		}
	}

	//检索框单击选中输入内容
	$('#FindTreeText').bind('click',function(){
		$('#FindTreeText').select()         
	});
	//查询按钮#pro_loc_bar
	/*$("#pro_loc_bar").keyup(function(){ 
		var searchStr = $("#FindTreeText").val(); 
		var searchStr =searchStr.toUpperCase();
		//var TextDesc =$.trim($('#FindTreeText').searchbox('getValue')); //检索的描述
		findByRadioCheck("catTree",searchStr,$("input[name='FilterCK']:checked").val())
		
	})	*/
	$('#FindTreeText').searchbox({
		    searcher:function(value,name){
		    	//alert(value+":"+name)
		    	findByRadioCheck("catTree",value,$("input[name='FilterCK']:checked").val())
		    }
		});
	//术语分类全部、已选、未选
	$HUI.radio("#pro_loc_bar [name='FilterCK']",{
        onChecked:function(e,value){
			//var searchStr = $("#FindTreeText").val(); 
			var searchStr = $.trim($('#FindTreeText').searchbox('getValue')); 
			var searchStr =searchStr.toUpperCase();
        	findByRadioCheck("catTree",searchStr,$(e.target).attr("value"))
       }
	});	
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
	/***********************************************专业科室功能结束********************************************* */	
}
$(init);