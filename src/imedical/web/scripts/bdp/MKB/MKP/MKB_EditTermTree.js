/// 名称: 医用知识库 -树型属性内容维护
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-丁亚男
/// 编写日期: 2018-03-30

var init = function(){	
	var HISUI_SQLTableName="MKB_Term",HISUI_ClassTableName="User.MKBTerm"+base;
	
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=DeleteData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=SaveData&pEntityName=web.Entity.MKB.MKBTerm";
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetMyList";
	
	var editIndex = undefined;  //正在编辑的行index
	var rowsvalue=undefined;   //正在编辑的行数据
	var oldrowsvalue=undefined;  //上一个编辑的行数据
	var preeditIndex="";     //上一个编辑的行index
	
	//treegrid列
	var columns =[[  
					{field:'id',title:'id',width:80,sortable:true,hidden:true,editor:'validatebox'},
					{field:'MKBTDesc',title:'中心词',width:150,sortable:true,editor:'validatebox'},
					{field:'MKBTSequence',title:'顺序',width:80,sortable:true,editor:'validatebox' },
					{field:'MKBTPYCode',title:'检索码',width:80,sortable:true,editor:'validatebox' },
					{field:'MKBTLastLevelF',title:'上级节点ID',width:80,sortable:false,editor:'validatebox',hidden:true},
					{field:'MKBTLastLevel',title:'上级节点',width:100,sortable:false,
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
						        		var ed = $('#mygrid').treegrid('getEditor', {index:editIndex,field:'MKBTLastLevelF'});
										$(ed.target).val(val)
									},100)
										
									
									if($(this).combo('getText')==""){
										$(this).combo('setValue',"")
									}
								}
							}
						}},
					{field:'MKBTNote',title:'备注',width:200,editor:{type:'textarea'}}
				]];
	//列表treegrid
	var mygrid = $HUI.treegrid("#mygrid",{
		url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetTreeJsonList&base="+base+"&rowid="+SelectTermID+"&desc="+MainDesc,
		columns:columns,
		//height:$(window).height()-105,   ///需要设置高度，不然数据展开太多时，列头就滚动上去了。
		idField: 'id',
		ClassName: "web.DHCBL.MKB.MKBTerm", //拖拽方法DragNode 存在的类 
		DragMethodName:"DragNode",
		treeField:'MKBTDesc',  //树形列表必须定义 'treeField' 属性，指明哪个字段作为树节点。
		autoSizeColumn:false,
		ContextMenuButton:'sss',
		animate:false,     //是否树展开折叠的动画效果
		//rownumbers:true,    //设置为 true，则显示带有行号的列。
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		//remoteSort:false,  //定义是否从服务器排序数据。true
		toolbar:'#mytbar',
		ClassTableName:HISUI_ClassTableName,
		SQLTableName:HISUI_SQLTableName,  
		onClickRow:function(index,row){
			//在左侧列表定位
			window.parent.Location(row.id)
			ClickFun();
			//保存历史和频次记录
			RefreshSearchData(HISUI_ClassTableName+base,row.id,"A",row.MKBTDesc)
		},		
		onDblClickRow:function(index,row){
			//双击事件
			DblClickFun(index,row)
		},
		onDrop: function(targetRow, sourceRow, point){
        	$(this).treegrid('enableDnd') //允许拖拽
        },	
        onLoadSuccess:function(data){
        	//$(this).treegrid('enableDnd', data?data.id:null);   //允许拖拽
			/*$('.mytooltip').tooltip({
				trackMouse:true,
				onShow:function(e){
					$(this).tooltip('tip').css({
						width:250 ,top:e.pageY+20,left:e.pageX-(250/2)
					});
				}

			});*/
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
        },
        onContextMenu:function (e, row) { //右键时触发事件
        },
        onBeforeSelect:function(node){
        	  $("#TextDesc").combobox("panel").panel("close")
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
	
	//重置按钮
	$("#btnRefresh").click(function (e) { 
		ClearFunLib();
	 }) 
 
	//添加按钮
	$("#add_btn").click(function (e) { 
		 append();
	}) 
	
	///保存按钮
	$("#save_btn").click(function (e) { 
		SaveFunLib();
	}) 
	
	//删除按钮
	$("#del_btn").click(function (e) { 
		DelData();
	})   
	
	
	//修改完后给这一行赋值
	function UpdataRow(row,id){
		
		//上级分类
		temp=row.MKBTLastLevel
		row.MKBTLastLevel=row.MKBTLastLevelF
		row.MKBTLastLevelF=temp
		
		//备注
		row.MKBTNote=row.MKBTNote.replace(/<br\/>/g,"\n"); 
		$('#mygrid').treegrid('update',{
			id: id,
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
	
	function Getrow(id){
		var rows=mygrid.getData();
		var value;
		getrowvlaue(rows,id);
		return value;
		function getrowvlaue(rows,id){
			for(var i=0;i<=rows.length-1;i++){
				if(rows[i].id==id){
					return value=rows[i]
					
				}
				var rowschildren=rows[i].children;
				if((rowschildren!=undefined)&&(rowschildren.length!=0)){
					getrowvlaue(rowschildren,id)
				}
			}
		}
	}
	
	//是否有正在编辑的行true/false
	function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#mygrid').treegrid('validateRow', editIndex)){
			$('#mygrid').treegrid('endEdit', editIndex);
			rowsvalue=Getrow(editIndex);
			//console.log(rowsvalue);
			//editIndex = undefined;
			return true;
		} else {
			return false;
		}
	} 
	
	//加载表达式、多行文本框等可编辑表格控件
	function AppendDom(){
		if (editIndex!=undefined)
		{
			var col=$('#layoutcenter').children().find('tr[node-id='+editIndex+']')[0];
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
			 //只有新增的时候展示名和检索码自动生成
			if (editIndex.indexOf("-u")!=-1)  
			{
				descTarget.keyup(function(){			
					var desc=descTarget.val()  //中心词列的值
					//检索码赋值
					var PYCode=Pinyin.GetJPU(desc)
					var PYCodeCol=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"MKBTPYCode"});							
					$(PYCodeCol.target).val(PYCode)
				})
			}
			
			//新增时或者检索码和展示名为空时：单击中心词，自动生成检索码和展示名
			descTarget.click(function(){
				var desc=descTarget.val()  //中心词列的值
				//检索码赋值
				var PYCode=Pinyin.GetJPU(desc)
				var PYCodeCol=$("#mygrid").datagrid("getEditor",{index:editIndex,field:"MKBTPYCode"});	
				if ((editIndex.indexOf("-u")!=-1)||(PYCodeCol.target.val()==""))
				{
					$(PYCodeCol.target).val(PYCode)
				}
			})
			
			
			
		}
	} 
	
	//grid单击事件
	function ClickFun(){   //单击执行保存可编辑行
		if (endEditing()){
			//console.log("1"+rowsvalue)
			//console.log("2"+oldrowsvalue)
			if(rowsvalue!= undefined){
				if((rowsvalue.MKBTDesc!="")){
					var differentflag="";
					if(oldrowsvalue!= undefined){
						var oldrowsvaluearr=JSON.parse(oldrowsvalue)
						for(var params in rowsvalue){
							if(oldrowsvaluearr[params]==undefined){oldrowsvaluearr[params]=""}
							if(rowsvalue[params]==undefined){rowsvalue[params]=""}
							if((oldrowsvaluearr[params]!=rowsvalue[params])&&(params!='children')){
								//alert(oldrowsvaluearr[params]+"&&"+rowsvalue[params])
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
				else{
					$.messager.alert('错误提示','中心词不能为空!',"error");
					$('#mygrid').treegrid('selectRow', editIndex)
						.treegrid('beginEdit', editIndex);
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
		if((row!=undefined)&&(row.id!=undefined)){
			UpdataRow(row,index)
		}
		preeditIndex=editIndex
		if (editIndex != index){
			if (endEditing()){
				$('#mygrid').treegrid('selectRow', index)
						.treegrid('beginEdit', index);
				editIndex = index;
			} else {
				$('#mygrid').treegrid('selectRow', editIndex);
			}
		}
		oldrowsvalue=JSON.stringify(row);   //用于和rowvalue比较 以判断是否行值发生改变
		AppendDom()
		
		//引用下拉框
		var ed =  $('#mygrid').treegrid("getEditor",{index:index,field:"MKBTLastLevel"});
		var idF =row.MKBTLastLevel
		if ((idF!="")&(idF!=undefined)){
			var url="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmbDesc&base="+base+"&id="+idF
			$(ed.target).combotree('reload',url);
		}		
		
	}
	
	
	UpdateData=function(){
		var node = $('#mygrid').treegrid('getSelected');
		onClickRow(node.id)
	}
	
	//右键添加同级或添加下级点击
	AddData=function (type){

		if(type==1) //添加同级
		{
			var node = $('#mygrid').treegrid('getSelected');
			var node=mygrid.getParent(node.id)
			append(node)
		}
		else  //添加下级
		{
			var node = $('#mygrid').treegrid('getSelected');
			append(node)
		}	

	}
	
	//新增一行
	function append(node){
		preeditIndex=editIndex;
		
		if(preeditIndex!=undefined){
			ClickFun()
		}
		
		function uuid() {
			var s = [];
			var hexDigits = "0123456789";
			for (var i = 0; i < 4; i++) {
				s[i] = hexDigits.substr(Math.floor(Math.random() * 10), 1);
			}
			var uuid = s.join("")+"-u";
			return uuid;
        }
		if (endEditing()){
			
			var uid=uuid();
			var _data="";
			//var Level=tkMakeServerCall("web.DHCBL.MKB.MKBInterfaceManage","GetLastSort",node.id) 
			
			if(node){
				_data={MKBTLastLevel:node.id,id:uid,MKBTDesc:"",  MKBTSequence:"", MKBTPYCode:"", MKBTNote:""};
				$('#mygrid').treegrid('append',{parent:node.id,data:[_data]});
			}
			else{
				_data={MKBTLastLevel:"",id:uid,MKBTDesc:"",  MKBTSequence:"", MKBTPYCode:"", MKBTNote:""};
				$('#mygrid').treegrid('append',{parent:null,data:[_data]});
			}
			editIndex=uid;
			$('#mygrid').treegrid('select', editIndex)
				.treegrid('beginEdit', editIndex);
				
			if(node){
				//上级分类加载数据
				var ed =  $('#mygrid').treegrid("getEditor",{index:editIndex,field:"MKBTLastLevel"});	
				var url="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmb&base="+base+"&id="+node.id
				$(ed.target).combotree('reload',url);
			}
		}
		AppendDom()
	}
	
	//点击保存按钮后调用此方法
	function SaveFunLib (){
		var ed = $('#mygrid').treegrid('getEditors',editIndex); 
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
	function SaveData(record){
		
		if (record.MKBTDesc=="")
		{
			$.messager.alert('错误提示','中心词不能为空!',"error");
			$('#mygrid').treegrid('select', editIndex)
				.treegrid('beginEdit', editIndex);	
			AppendDom()
			return;
		}
		if(record.id.indexOf("-u")>=0){
			record.id="";

		}
		//在修改添加时判断选中的上级是不是本身或者自己的下级
		/*if (record.id!="")
		{
			var comboId=record.MKBTLastLevel;
			if(justFlag(comboId,record.id,"mygrid"))
			{
				$('#mygrid').treegrid('select', editIndex)
				.treegrid('beginEdit', editIndex);	
				return;				
			}	
		}*/
		record.MKBTBaseDR=base
		record.children=""
		//执行保存
		$.ajax({
			type: 'post',
			url: SAVE_ACTION_URL,
			data: record,
			success: function (data) { //返回json结果			
				var data=eval('('+data+')');
				if(data.success=='true'){
				   $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
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
				  rowsvalue=undefined;
				  editIndex=undefined;
				  $('#mygrid').treegrid('reload');
				  /*if(record.id==""){
				  	$('#mygrid').treegrid('unselectAll');
				  }*/
				}
				else{
					var errorMsg="保存失败！";
					if(data.errorinfo){
						errorMsg=errorMsg+'</br>错误信息:'+data.errorinfo
					}
					$.messager.alert('错误提示',errorMsg,'error')
			   }
			}
		});
		
	}

	///删除
	DelData=function()
	{        
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
						"id":record.id      ///rowid
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
								//保存历史和频次记录
								RefreshSearchData("User.MKBTerm"+base,record.id,"D","")
								$('#mygrid').treegrid('reload');  // 重新载入当前页面数据
								$('#mygrid').treegrid('unselectAll');
							} 
							else { 
								var errorMsg =""
								if (data.info) {
									errorMsg =errorMsg+ '错误信息:' + data.info
								}
								$.messager.alert('操作提示',errorMsg,"error");
					
							}			
					}  
				})
			}
		});
	}
	

	 //查询方法
	SearchFunLib=function()
	{
		//var TextDesc =$.trim($('#TextDesc').searchbox('getValue')); //检索的描述
		var TextDesc=$("#TextDesc").combobox('getText')
		$('#mygrid').treegrid('load',  { 
			ClassName:"web.DHCBL.MKB.MKBTerm",
			QueryName:"GetTreeJsonList",
			'base':base,
			'rowid':"",
			'desc':TextDesc
		});
	}
	
	//重置方法
	ClearFunLib=function()
	{
		editIndex = undefined;  //正在编辑的行index
		rowsvalue=undefined;   //正在编辑的行数据
		//$("#TextDesc").searchbox('setValue', '');
		$("#TextDesc").combobox('setValue', '');
		$('#mygrid').treegrid('load',  { 
			ClassName:"web.DHCBL.MKB.MKBTerm",
			QueryName:"GetTreeJsonList",
			'base':base,
			'rowid':"",
			'desc':""
		});
		$('#mygrid').treegrid('unselectAll');
		
		//父界面重置
		window.parent.ClearFunLibTree()
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
	        	$('#knoExe').css('display','none'); 
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
	
};
$(init);
