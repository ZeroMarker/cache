var init = function(){
	var SelTagArr=new Array();

	//**********左侧标记检索列表******************/
	//重载标记列表按钮
	$("#btnReloadTag").click(function(e){
		$("#TagForm").empty();
		SelTagData="";
		indexTagParent="";
		LoadTagData($("#SelTagStr").val(),indexTagParent)
	})
	$HUI.datagrid("#Form_TagSearchGrid",{
		columns: [[    
			{field:'text',title:'标记名称',width:200,sortable:true},
			{field:'id',title:'标记id',width:200,sortable:true,hidden:true}
		]],
		pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:100,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		showHeader:false,
		idField: 'id',    
		textField: 'text',  
		rownumbers:false,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		resizable:true,
		fixed:true,
		remoteSort:false,  //定义是否从服务器排序数据。true
		onLoadSuccess:function(data){
			//调整行高
			var panel = $(this).datagrid('getPanel');   
	        var tr = panel.find('div.datagrid-body tr');   
	        tr.each(function(){   
	          	$(this).css({"height": "20px"})
	        });  
	        $('#Form_TagSearchGrid').datagrid('unselectAll');
		},
		onClickRow:function(rowIndex,rowData){
			var selected = $('#Form_TagSearchGrid').datagrid('getSelected');  
			if (selected) { 
				var id=selected.id; 
				var childid=id.split("#")[0]; //根节点
				var tagid=id.split("#")[1]; //当前节点
				var node = $("#Tag"+childid+"").tree('find', tagid);
				$("#Tag"+childid+"").tree("check",node.target);
		        //展示所有父节点  
		        $(node.target).show();  
		        $(".tree-title", node.target).addClass("tree-node-targeted");  
		        //展开到该节点 
		        $("#Tag"+childid+"").tree("expandTo",node.target);			        
		        //如果是非叶子节点，需折叠该节点的所有子节点  
		        if (!$("#Tag"+childid+"").tree("isLeaf",node.target)) { 
		        	$("#Tag"+childid+"").tree("collapse",node.target);
				} 
			}
		}
	})
	function LoadFormTagSearchData(indexTagParent,desc){
		var opts = $('#Form_TagSearchGrid').datagrid("options");
		//opts.url=$URL+"?ClassName=web.DHCBL.MKB.SDSDiagnos&QueryName=GetTagList&ResultSetType=array&parentid="+indexTagParent+"&desc="+desc;
		opts.url=$URL+"?ClassName="+ServerObject.LoadTagSearchMethod.split("#")[0]+"&QueryName="+ServerObject.LoadTagSearchMethod.split("#")[1]+"&ResultSetType=array&parentid="+indexTagParent+"&desc="+desc;
		$('#Form_TagSearchGrid').datagrid("load");
	}
	//**********中间已选标记列表******************/
	$HUI.datagrid("#Form_TagSelectedGrid",{
		columns: [[    
			{field:'index',title:'index',width:30,sortable:true,hidden:true},
			{field:'titleid',title:'标记标题id',width:60,sortable:true,hidden:true},
			{field:'title',title:'标记标题',width:80,sortable:true,
				formatter:function(value,rec){ 
			   	  //鼠标悬浮显示全部
					return "<span class='hisui-tooltip' title='"+value+"'>"+value+"</span>" 
                } 
			},
			{field:'text',title:'已选标记',width:200,sortable:true,
				formatter:function(value,rec){ 
					if (value.length<10){
						var showValue=value
					}else{
						var showValue=value.substr(0,12)+"..."
					}
			   	  //鼠标悬浮显示全部
					return "<span class='hisui-tooltip' title='"+value+"'>"+showValue+"</span>" 
                } 
	         },
			{field:'id',title:'已选标记id',width:30,sortable:true,hidden:true}
		]],
		pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:100,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		showHeader:false,
		idField: 'id',    
		textField: 'text',  
		rownumbers:false,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		resizable:true,
		fixed:true,
		remoteSort:false,  //定义是否从服务器排序数据。true
		sortName:'index',  
		sortOrder:'asc',
		onClickCell:function(rowIndex, field, value){
			if (field=="title"){
				$("#TagForm").empty();
				//获取中间已选列表标题id
				var rows = $('#Form_TagSelectedGrid').datagrid('getRows');
				indexTagParent = rows[rowIndex].titleid.split("seltag")[1];
				LoadTagData($("#SelTagStr").val(),indexTagParent)
			}else{
				if (value=="") return;
				var childId=$('#Form_TagSelectedGrid').datagrid('getRows')[rowIndex].titleid.split("seltag")[1]
				var tagid=$('#Form_TagSelectedGrid').datagrid('getRows')[rowIndex].id
				var node = $("#Tag"+childId+"").tree('find', tagid);
				scrollToLocation(node.target.id); //跳转相应勾选标记位置
			}
		},
		onRowContextMenu: function(e, rowIndex, rowData){   //右键菜单
			var $clicked=$(e.target);
			copytext =$clicked.text()||$clicked.val()   //普通复制功能
			
			e.preventDefault();  //阻止浏览器捕获右键事件
			var record=$(this).datagrid("selectRow", rowIndex); //根据索引选中该行  
			$('#selTagMenu').menu('show', {    
				  left:e.pageX,  
				  top:e.pageY
			})
		},
		onLoadSuccess: function(data){                      //data是默认的表格加载数据，包括rows和Total
			var mark=1;                                                 //这里涉及到简单的运算，mark是计算每次需要合并的格子数
			for (var i=1; i <data.rows.length; i++) {     //这里循环表格当前的数据
		　　　 		if(data.rows[i]['title'] == data.rows[i-1]['title']){   //后一行的值与前一行的值做比较，相同就需要合并
			　　　　	mark += 1;                                            
			　　　　　　　$(this).datagrid('mergeCells',{ 
			　　　　　　　　　　index: i+1-mark,                 //datagrid的index，表示从第几行开始合并；紫色的内容需是最精髓的，就是记住最开始需要合并的位置
			　　　　　　　　　　field: 'title',                 //合并单元格的区域，就是clomun中的filed对应的列
			　　　　　　　　　　rowspan:mark                   //纵向合并的格数，如果想要横向合并，就使用colspan：mark
			　　　　　　　}); 
		　　　　　　	}else{
		　　　　　　　		mark=1;                                         //一旦前后两行的值不一样了，那么需要合并的格子数mark就需要重新计算
		　　　　　　	}
	　　　　	}
	　	}
	});
	function scrollToLocation(scrollToId) {
	    var mainContainer = $('#TagPanel');
	    var scrollToContainer = $('#'+scrollToId);
	    //非动画效果
	    /*mainContainer.scrollTop(
	    	scrollToContainer.offset().top - mainContainer.offset().top + mainContainer.scrollTop()
	    );*/
	    //动画效果
	    mainContainer.animate({
	    	scrollTop: scrollToContainer.offset().top - mainContainer.offset().top + mainContainer.scrollTop()
	    }, 200);
	}
	//已选标记列表 右键复制按钮 
	$("#CopySelTag").click(function (e) { 
		var aux=document.getElementById("Form_TagSelCopyText"); 
		aux.value=copytext; //赋值
		aux.select(); // 选择对象 
		document.execCommand("Copy"); // 执行浏览器复制命令 
	 })
	 //已选标记列表 右键删除按钮
	$("#DelSelTag").click(function (e) { 
		var record = $('#Form_TagSelectedGrid').datagrid('getSelected'); 
		var childId=record.titleid.split("seltag")[1]
		var id=record.id;
		var node = $("#Tag"+childId+"").tree('find',id); 
		$("#Tag"+childId+"").tree('uncheck',node.target);
	})
	//**********右侧完整标记列表******************/
	LoadTagData=function(CheckedTagStr,indexTagParent){
		//左侧标记列表加载
		LoadFormTagSearchData(indexTagParent,"")
		//左侧标记列表检索框定义
		$('#Form_TagSearchText').searchbox({
		   searcher : function (value, name) { // 在用户按下搜索按钮或回车键的时候调用 searcher 函数
				LoadFormTagSearchData(indexTagParent,value);
		   }
		})
		$('#Form_TagSearchText').searchbox('setValue','')
		$('#Form_TagSearchText').searchbox('textbox').focus();
		//标记列表检索框实时检索
		$('#Form_TagSearchText').searchbox('textbox').unbind('keyup').keyup(function(e){
			LoadFormTagSearchData(indexTagParent,$('#Form_TagSearchText').searchbox('textbox').val() );
		}); 	
		$('#Form_TagSearchText').searchbox('textbox').bind('click',function(){ 
			$('#Form_TagSearchText').searchbox('textbox').select()    //重新点击时 默认之前输入的值为选中状态，方便删除     
		});
		var TreeCheckedIdStr=""
		if (SelTagData!=""){
			TreeCheckedIdStr=SelTagData
		}else{
			TreeCheckedIdStr=CheckedTagStr
		}
		SelTagArr=[];
		var TagFormTool='<tr id="tagTemplate" style="display:none;"><td nowrap style="white-space:nowrap;word-break:nowrap" class="td_label"><label for="email">时效</label></td></tr>'
		$("#TagForm").append(TagFormTool)
		var $ff=$("#TagForm"); //table
		var $templ=$("#tagTemplate"); //tr
		//var RetStr = cspRunServerMethod(ServerObject.GetTagTemplate); 
		var RetStr = tkMakeServerCall(ServerObject.GetTagTemplate.split("#")[0],ServerObject.GetTagTemplate.split("#")[1]) 
		if (RetStr!=""){
			var modeJsonInfo=$.parseJSON(RetStr);
			$(modeJsonInfo).each(function(index,item){
					var childId=modeJsonInfo[index].catRowId; 
					var childDesc=modeJsonInfo[index].catDesc; 
					var choiceType=modeJsonInfo[index].choiceType; //单选多选配置：默认多选
					var tagSelectFlag= true;//默认单选
					if (choiceType=="多选"){
						tagSelectFlag= false; //根据属性获取单选多选配置
					}else{
						tagSelectFlag= true;
					}
					
					var tool=$templ.clone();
					tool.removeAttr("style");
					tool.removeAttr("id");
					tool.attr("id",childId);
					tool.addClass("tag_tr");
					tool.addClass("tr_dispaly");
					$ff.append(tool);
					//分词点击功能：点击诊断标记显示所有，点击标记标题加载相应的标记列表,隐藏其他标记列表
				 	if ((indexTagParent!=undefined)&&(indexTagParent!="")){
				 		if (childId!=indexTagParent){
					 		$(tool).css("display","none")
					 	}else{
					 		$(tool).css("display","")
					 	}
				 	}
					//属性名称列设置颜色交替变换
					if (index%2==0){
						$("td",tool).css("backgroundColor","#EEFAF4")
					}else{
						$("td",tool).css("backgroundColor","#FBF9F2")
					}
					//诊断属性悬浮显示属性名
					$("td",tool).tooltip({
					    position: 'right',
					    content: '<span style="color:#fff">'+childDesc+'</span>',
					    onShow: function(){
							$(this).tooltip('tip').css({
								backgroundColor: '#666',
								borderColor: '#666'
							});
					    }
					});
					$("label",tool).removeAttr("style");
					$("label",tool).html(childDesc);
					var TreeRetUrl="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetTreeJson&&base="+baseTag+"&id="+childId
					var Tree_tool="<td width=400><ul class='hisui-tree' id='Tag"+childId+"'></ul></td>"
					tool.append(Tree_tool);
					var tree=$HUI.tree("#Tag"+childId+"",{
						checkbox:true,
						//onlyLeafCheck:true,
						lines:true,
						multiple:tagSelectFlag,
						cascadeCheck:false,
						url:TreeRetUrl,
						formatter:function(node){
							return node.MKBTDesc;
						},
						onClick:function(node){
							if (node.checked){
								$(this).tree('uncheck',node.target)  
							}else{
								$(this).tree('check',node.target)  
							}
						},
						onCheck:function(node, checked){
								var SelTagType=""
								if (checked==true){
									if (node.checked==false){
										SelTagType="add"
										//勾选时对全局变量已选标记赋值
										if (SelTagData==""){
											SelTagData=node.id
										}else{
											if ((SelTagData+",").indexOf(node.id+",")<0){ //去重
												SelTagData=SelTagData+","+node.id
											}
										}
									}
								}else{
									SelTagType="remove"
									//取消勾选时修改全局变量已选标记，清除取消勾选项
									SelTagData=(SelTagData+",").replace((node.id+","),"")
									if(SelTagData.charAt(SelTagData.length-1)==","){
										SelTagData=SelTagData.substring(0, SelTagData.length-1)
									}
								}
								if (tagSelectFlag==false){//多选模式
									if (checked){
									   if (!$(this).tree("isLeaf",node.target)) $(this).tree("expand",node.target);
									}
								}else{
									var nodes =$("#Tag"+childId+"").tree('getChecked');
									if(nodes.length>1){ 
										for (var i=0;i<nodes.length;i++){
											var ids=nodes[i].id;
											if (ids==node.id) {
												continue
											}
											var node1 = $("#Tag"+childId+"").tree('find',ids); 
											$("#Tag"+childId+"").tree('uncheck',node1.target);
										}
								    }
								}
								 //获取当前选中节点的所有父节点 concat
								 var parentAll = "";
								 parentAll = node.MKBTDesc;
								 var flag = "，";
								 var parent = $("#Tag"+childId+"").tree('getParent', $("#Tag"+childId+"").tree('find',node.id).target); //获取选中节点的父节点
								 for (n = 0; n < 6; n++) { //可以视树的层级合理设置k
								     if (parent != null) {
								         parentAll = flag.concat(parentAll);
								         parentAll = (parent.MKBTDesc).concat(parentAll);
								         var parent = $("#Tag"+childId+"").tree('getParent', parent.target);
								     }
								 }
								 parentAll=parentAll.split("，").reverse().join("，"); //父子级倒序显示
								 if (SelTagType=="add"){
									SaveSelTagData(index,"seltag"+childId,childDesc,node.id,parentAll,SelTagType)
								 }
								 else if(SelTagType=="remove"){
								 	SaveSelTagData(index,"seltag"+childId,childDesc,node.id,parentAll,SelTagType)
								 }
								 //全局化词表调用时，勾选展示名或临床实用诊断后自动勾选查询名  需外层文件设置var flagMKBTable="MKB_Globalend"全局变量
								 if(typeof(flagMKBTable)!="undefined"){
									if (flagMKBTable=="MKB_Globalend"){
										if ((node.MKBTDesc=="展示名")||(node.MKBTDesc=="临床实用诊断")){
											var RootQueryNameId=tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","GetCheckedTagIdStr","通用")
											var nodeQueryNameId=tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","GetCheckedTagIdStr","查询名")
											var nodeQueryName = $("#Tag"+RootQueryNameId+"").tree('find',nodeQueryNameId); 
											if (nodeQueryName!=null){
												if(nodeQueryName.checked==false){
													$("#Tag"+RootQueryNameId+"").tree('check',nodeQueryName.target);
												}
											}
										}
									}
								 }
							},
							onLoadSuccess:function(node, data){
								var Roots=$(this).tree('getRoots');
								for (var j=0;j<Roots.length;j++){
									if (!$(this).tree("isLeaf",Roots[j].target)) $(this).tree("collapseAll",Roots[j].target);
								}
								if (TreeCheckedIdStr!=""){
									for (var m=0;m<TreeCheckedIdStr.split(",").length;m++){
										var tmpnode = $(this).tree('find', TreeCheckedIdStr.split(",")[m]);
										if (tmpnode){
											$(this).tree('check', tmpnode.target);
											$(this).tree("expandTo",tmpnode.target);
										}
									}
								}
								
								for (var j=0;j<Roots.length;j++){
										if (!$(this).tree("isLeaf",Roots[j].target)) $(this).tree("expand",Roots[j].target);
								}
								SaveSelTagData(index,"seltag"+childId,childDesc,"","","add")
							}
					})
			});
		}
	}
	
	function SpliceSelTag(pindex,pid,type){
		for(var i in SelTagArr){
			var obj=SelTagArr[i]
			if (pindex==obj.index){
				if (type=="add"){
					if(obj.id==""){ //清除标题行
						SelTagArr.splice(i,1)
					}
				}else{
					if (pid==""){ //清除所有
						SelTagArr.splice(i,1)
					}else{
						if (pid==obj.id){ //清除当前选中
							SelTagArr.splice(i,1)
						}
					}
				}
			}
		}
	}
	function GetSelTagNum(pindex){
		var num=0;
		for(var i in SelTagArr){
			var obj=SelTagArr[i]
			if (pindex==obj.index){
				num++;	
			}
		}
		return num;
	}
	//属性列表勾选对已选列表赋值
	function SaveSelTagData(pindex,ptitleid,ptitle,pid,ptext,type){
		//console.log(pindex+","+ptitleid+","+ptitle+","+pid+","+ptext+","+type)
		if(type=="add")
		{
	 	 	SelTagArr.push({"index":pindex,"titleid":ptitleid,"title":ptitle,"text":ptext,"id":pid});
	 	 	SpliceSelTag(pindex,pid,type);
	 	 	if((GetSelTagNum(pindex)==0)&&(pid=="")){
	 	 		SelTagArr.push({"index":pindex,"titleid":ptitleid,"title":ptitle,"text":"","id":""});
	 	 	}
	 	 	$("#Form_TagSelectedGrid").datagrid("loadData",SelTagArr)
		}
		if(type=="remove")
		{
			SpliceSelTag(pindex,pid,type);
			if(GetSelTagNum(pindex)==0){
				SelTagArr.push({"index":pindex,"titleid":ptitleid,"title":ptitle,"text":"","id":""});
			}
			$("#Form_TagSelectedGrid").datagrid("loadData",SelTagArr)
		}
		if(indexTagParent!=undefined){
			//选中已选属性列表行
			var data=$('#Form_TagSelectedGrid').datagrid('getData')
			for (var i=1; i <data.rows.length; i++) { 
	 			if (data.rows[i]['titleid']=="seltag"+indexTagParent){
					$('#Form_TagSelectedGrid').datagrid('selectRow', i); //选中对应的行
					return;
				}
	 		}
		}else{
			$('#Form_TagSelectedGrid').datagrid('clearSelections')
		}
	}
	//记录基础代码数据使用频次 
	SaveTagFreq=function(ValueId, ValueDesc, TableName) {
		if (flagSaveFreq=="false") return;
	    var FrequencyStr=TableName+"^"+ValueId+"^"+ValueDesc+"^^"
	    var rtn = tkMakeServerCall("web.DHCBL.BDP.BDPDataFrequency", "SaveData", FrequencyStr)
	}
	//获取需要保存的勾选标记id串，逗号分隔
	GetTagValue=function(){
		var DataStr="";
		var DescStr=""
    	var $tag_tr=$(".tag_tr"); 
		for (var i=0;i<($tag_tr.length);i++){
			var trids=$tag_tr[i].id; 
			var tds=$("#"+trids+"").children();
			for (var j=1;j<tds.length;j++){
				//var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
				var detailId=""
				var details=$("#"+trids+" td").children();
				for (var k=1;k<details.length;k++){
					if (k==1){
						detailId=details[k].id
					}
				}
				var CheckedId=""; 
				var CheckedDesc=""; 
				var treeCheckedIds=$("#"+detailId+"").tree('getChecked');
				for (var k=0;k<treeCheckedIds.length;k++){
					var OneTreeCheckedId=treeCheckedIds[k].id;
					var OneTreeCheckedDesc=treeCheckedIds[k].MKBTDesc;
					if (CheckedId==""){
						CheckedId=OneTreeCheckedId;
					} else{
						CheckedId=CheckedId+","+OneTreeCheckedId;
					}
					if (CheckedDesc==""){
						CheckedDesc=OneTreeCheckedDesc;
					} else{
						CheckedDesc=CheckedDesc+","+OneTreeCheckedDesc;
					}
					var rootid=detailId.split("Tag")[1]
					SaveTagFreq(rootid+"#"+OneTreeCheckedId, OneTreeCheckedDesc,"User.SDSTag")
				}
				if (CheckedId!=""){
					if (DataStr=="") DataStr=CheckedId;
				    else  DataStr=DataStr+","+CheckedId;
			    }
				if (CheckedDesc!=""){
					if (DescStr=="") DescStr=CheckedDesc;
				    else  DescStr=DescStr+","+CheckedDesc;
			    }
			}
		}
		var DiagnosTagStr=DataStr+"#"+DescStr;
		return DiagnosTagStr;
	}
}
$(init);