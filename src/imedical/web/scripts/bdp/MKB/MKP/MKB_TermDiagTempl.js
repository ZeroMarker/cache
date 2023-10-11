/// 名称: 诊断学_临床实用诊断 诊断模板预览界面
/// 描述: 诊断模板预览功能
/// 编写者: 基础数据平台组-高姗姗
/// 编写日期: 2018-08-15
var MRCICDRowid=GetParams("MKBTRowId") //诊断id
function GetParams(name){
        var search = document.location.search;
        var pattern = new RegExp("[?&]"+name+"\=([^&]+)", "g");
        var matcher = pattern.exec(search);
        var items = null;
        if(null != matcher){
                try{
                        items = decodeURIComponent(decodeURIComponent(matcher[1]));
                }catch(e){
                        try{
                                items = decodeURIComponent(matcher[1]);
                        }catch(e){
                                items = matcher[1];
                        }
                }
        }
        return items;
};
var init = function(){
		var DisplayNameFlag="",DisplayDiagList="";
		var $ff=$("#DiagForm"); //table
		var $templ=$("#formTemplate"); //tr
		var RetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDiaTemplate",MRCICDRowid)
		if (RetStr!=""){
			var RetStrArr=RetStr.split("^");
			var DKBBCRowId=RetStrArr[0]; //属性模板Id
			var emptyInfo=RetStrArr[1];
			if (emptyInfo=="") {
				return ;
			}
			var modeJsonInfo=$.parseJSON(RetStrArr[2]);
			$(modeJsonInfo).each(function(index,item){
					var childId=modeJsonInfo[index].catRowId; 
					var childDesc=modeJsonInfo[index].catDesc;
					var childType=modeJsonInfo[index].catType; //L列表 T树形 TX文本 S引用术语类型 C下拉框
					var showType=modeJsonInfo[index].showType;  //['C','下拉框'],['T','下拉树'],['TX','文本框'],['TA','多行文本框'],['CB','单选框'],['CG','复选框']
					var catFlag=modeJsonInfo[index].catFlag; //Y 表示诊断展示名
					var treeNode=modeJsonInfo[index].treeNode; //起始节点
					var choiceType=modeJsonInfo[index].choiceType; //单选多选配置：S单选;D多选
					var ifRequired=modeJsonInfo[index].ifRequired; //是否必填项:Y是；N否
					var isTOrP=modeJsonInfo[index].isTOrP; //引用属性：P，引用术语:T
					var trId=DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP;
					var trName=childDesc+"_"+ifRequired;
					var proSelectFlag= true;//默认单选
					if (choiceType=="D"){
						proSelectFlag= false; //根据诊断模板获取多选
					}else{
						proSelectFlag= true;
					}
					if (childType=="L"){
						if (isTOrP=="P"){
							var ListRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetListDetailInfo", "", childId, "0", "1000"); 
							ListRetStr=eval("("+ListRetStr+")");
							var C_valueField='MKBTPDRowId';  
							var C_textField='comDesc'; //展示名
						}else{ //术语标识
							var ListRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetListTermJsonForDoc", "", childId, "", "1000", "1");
							ListRetStr=eval("("+ListRetStr+")");
							var C_valueField='MKBTRowId';  
							var C_textField='MKBTDesc'; //中心词
						}
					}
					if (childType=="T"){
						if (isTOrP=="P"){
							var TreeRetUrl="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetTreeDetailJson&id="+treeNode+"&property="+childId
						}else{ //术语标识
							var TreeRetUrl="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetTreeTermJsonForDoc&id="+treeNode+"&base="+childId
						}
					}
					if ((childType=="TX")||(childType=="TA")||(childType=="R")||(childType=="CB")||(childType=="C")){
						var TXRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetTextInfo",childId); 
					}
					if (childType=="S"){
						if ((showType=="C")||(showType=="CB")||(showType=="CG")) { //引用术语 展示为下拉框
							var ListRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDocSourseList", childId, showType, ""); 
							ListRetStr=eval("("+ListRetStr+")");
							var C_valueField='MKBTRowId';  
							var C_textField='MKBTDesc';
						}
						else if (showType=="T"){
							var TreeRetUrl="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetDocSourseTreeJson&LastLevel=&property="+childId
						}
						else{
							var SRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDocSourseDetailInfo",childId); 
						}
					}
					if (childType=="P"){
						var ListRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDocPropertyList",childId, ""); 
						ListRetStr=eval("("+ListRetStr+")")
						if (showType=="C") {
							var C_valueField='catRowId';  
							var C_textField='catDesc';
						}
					}
					if (childType=="SS"){
						var TreeRetUrl="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetSSProDetailJsonForDoc&property="+childId
					}
						var tool=$templ.clone();
						tool.removeAttr("style");
						tool.removeAttr("id");
						tool.attr("id",trId);
						tool.attr("lang",trName); //201917 title						tool.addClass("dynamic_tr");
						tool.addClass("dynamic_tr");
						tool.addClass("tr_dispaly");
						$ff.append(tool);
						
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
						//['C','下拉框'],['T','下拉树'],['TX','文本框'],['TA','多行文本框'],['CB','单选框'],['CG','复选框']
						//必填项区分
						if (ifRequired=="Y"){
							$("label",tool).html("<font color=red>*</font>"+childDesc);
						}else{
							$("label",tool).html(childDesc);
						}
						
						if (showType=="TX"){
							if (childType=="S"){
								var TXText=SRetStr.split("[A]")[2];
								var TXId=SRetStr.split("[A]")[1];
							}else{
							    var TXText=TXRetStr.split("[A]")[1];
							    var TXId=TXRetStr.split("[A]")[0];
							}
							var TX_tool="<td><label id='"+childId+"_"+TXId+"_TX"+isTOrP+"'>"+TXText+"</label></td>"  
							tool.append(TX_tool);
						}
						if (showType=="TA"){
							var TAId=""
							if (childType=="S"){
								var TAText=SRetStr.split("[A]")[2];
								TAId=SRetStr.split("[A]")[1];
							}else{
								TAId=TXRetStr.split("[A]")[0];
								var TAText=TXRetStr.split("[A]")[1];
							}
							var TA_tool="<td><textarea disabled='disabled' style='width:98%;background:transparent;border:0px;' id='"+childId+"_"+TAId+"_TA"+isTOrP+"'>"+TAText+"</textarea></td>"  
							tool.append(TA_tool);
						}
						if (showType=="CB"){
							var CBRetStr = ListRetStr;
							var TA_tool="";
							for (var k=0;k<CBRetStr.data.length;k++){
								if (isTOrP=="T"){ //术语标识
									var CBId=CBRetStr.data[k].MKBTRowId;
		                        	var CBDesc=CBRetStr.data[k].MKBTDesc;
								}else{
									if (childType=="S"){
										var CBId=CBRetStr.data[k].MKBTRowId;
		                        		var CBDesc=CBRetStr.data[k].MKBTDesc;
									}else if(childType=="P"){
										var CBId=CBRetStr.data[k].catRowId;
		                        		var CBDesc=CBRetStr.data[k].catDesc;
									}else{
										var CBId=CBRetStr.data[k].MKBTPDRowId;
		                        		var CBDesc=CBRetStr.data[k].comDesc;
									}
								}
				                var OneTA_tool="<input type='radio' style='vertical-align:middle;padding:0px;' name='"+childId+"_"+index+"_CB"+isTOrP+"'"+"id='"+childId+"_"+CBId+"_CB"+isTOrP+"'/>"+"<span>"+CBDesc+"</span>"
				              
		                        if (TA_tool=="") TA_tool="<td>"+OneTA_tool;
		                        else TA_tool=TA_tool+OneTA_tool;
							}
							if (TA_tool!=""){
								TA_tool=TA_tool+"</td>";
								tool.append(TA_tool);
							}
						}
						if (showType=="CG"){
							var CGRetStr = ListRetStr 				
							var TA_tool="";
							for (var k=0;k<CGRetStr.data.length;k++){
								if (isTOrP=="T"){ //术语标识
									var CGId=CGRetStr.data[k].MKBTRowId;
			                        var CGDesc=CGRetStr.data[k].MKBTDesc;
								}else{
									if (childType=="S"){
										var CGId=CGRetStr.data[k].MKBTRowId;
			                        	var CGDesc=CGRetStr.data[k].MKBTDesc;
									}else if(childType=="P"){
										var CGId=CGRetStr.data[k].catRowId;
			                        	var CGDesc=CGRetStr.data[k].catDesc;
									}else{
										var CGId=CGRetStr.data[k].MKBTPDRowId;
			                        	var CGDesc=CGRetStr.data[k].comDesc;
									}
								}
				                var OneTA_tool="<input type='checkbox' style='vertical-align:middle;padding:0px;' name='"+childId+"_"+index+"_CG"+isTOrP+"'"+"id='"+childId+"_"+CGId+"_CG"+isTOrP+"'/>"+"<span>"+CGDesc+"</span>"
				               
		                        if (TA_tool=="") TA_tool="<td>"+OneTA_tool;
		                        else TA_tool=TA_tool+OneTA_tool;
							}
							if (TA_tool!=""){
								TA_tool=TA_tool+"</td>";
								tool.append(TA_tool);
							}
						}
						if (showType=="C"){
							var Data=ListRetStr.data;
							var Combo_tool="<td><input class='hisui-combobox' id='"+childId+"_C"+isTOrP+"' /></td>" 
							tool.append(Combo_tool);
							$HUI.combobox("#"+childId+"_C"+isTOrP+"",{
								editable: true,
								multiple:false,
								width:'250',
								//selectOnNavigation:true,
							  	valueField:C_valueField,   
							  	textField:C_textField,
							  	data:Data,
	                			formatter:function(row){ // 鼠标悬浮显示备注
							  		if (childType=="L"){ 
										if (isTOrP=="P"){
											if (row.MKBTPDRemark!=""){
												return '<span class="hisui-tooltip" title="'+row.MKBTPDRemark+'">'+row.comDesc+'</span>';
											}else{
												return row.comDesc;
											}
							  			}else{ //术语标识
							  				return row.MKBTDesc;
										}
							  		}else if (childType=="S"){
							  			return row.MKBTDesc;
							  		}else if (childType=="P"){
							  			return row.catDesc;
							  		}else{
							  			return row.comDesc;
							  		}
								}
							});
						}
						if (showType=="T"){
							if (childDesc=="文本"){
								var TA_tool="<td><textarea style='width:250px;height:80px' id='"+childId+"_T"+isTOrP+"_"+treeNode+"'></textarea></td>"  
								tool.append(TA_tool);
							}else{
								var Tree_tool="<td width=400><ul class='hisui-tree' id='"+childId+"_T"+isTOrP+"_"+treeNode+"'></ul></td>"
								tool.append(Tree_tool);
								var tree=$HUI.tree("#"+childId+"_T"+isTOrP+"_"+treeNode+"",{
									checkbox:true,
									//onlyLeafCheck:true,
									lines:true,
									multiple:proSelectFlag,
									cascadeCheck:false,
									//data:TreeRetStr,
									url:TreeRetUrl, 
									formatter:function(node){
										if (childType=="T"){
			              					//鼠标悬浮显示备注
			                  				var remark=node.text.split("^")[3].split("</span>")[0];
											if (remark!=""){
												return '<span class="hisui-tooltip" title="'+remark+'">'+node.text+'</span>';
											}else{
												return node.text;
											}
										}else{
											return node.text;
										}
									},
									onContextMenu: function(e, node){ //诊断属性右键菜单gss   
											e.preventDefault();  //阻止右键默认事件 
										    $("#NodeMenu").empty(); //	清空已有的菜单
											$(this).tree('select',node.target);
												$('#NodeMenu').menu('appendItem', {
													text:"知识点",
													iconCls:'icon-productimage',
													onclick:function(){
														var height=parseInt(window.screen.height)-120;
														var width=parseInt(window.screen.width)-50;
														if (isTOrP=="P"){
															var repUrl="dhc.bdp.mkb.mkblistterm.csp?BDPMENU="+menuid+"&TermID="+MRCICDRowid+"&ProId="+childId+"&detailId="+node.id; 
														}else{
															var termmenuid=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetMenuId",childDesc); 
															var repUrl="dhc.bdp.mkb.mkblistterm.csp?BDPMENU="+termmenuid+"&TermID="+node.id+"&ProId="; 
														}
														var listtermWin=window.open(repUrl,"_blank","height="+height+",width="+width+",left=20,top=20,resizable=yes,titlebar=no,toolbar=no,menubar=no,scrollbar=no,location=no,status=no",true)
														setTimeout(function(){ listtermWin.document.title = '知识点'; }, 150)
													}
												})
											$('#NodeMenu').menu('appendItem', {
												text:"关联ICD",
													iconCls:'icon-paper-link',
													onclick:function(){
														var repUrl="dhc.bdp.mkb.mkbrelatedicd.csp?diag="+MRCICDRowid+"-"+childId+":"+node.id+"&dblflag=N&DiagnosValue="; 
														var relatedicdWin=window.open(repUrl,"_blank","height=600,width=1000,left=50,top=50,resizable=yes,titlebar=no,toolbar=no,menubar=no,scrollbar=no,location=no,status=no",true)
														setTimeout(function(){ relatedicdWin.document.title = '关联ICD'; }, 100)
													}
	
											})
											$('#NodeMenu').menu('appendItem', {
												text:"相关文献",
												iconCls:'icon-paper',
												onclick:function(){
					                            	var repUrl="dhc.bdp.mkb.mkbrelateddocuments.csp?diag="+MRCICDRowid+"-"+childId+":"+node.id; 
													var documentsWin=window.open(repUrl,"_blank","height=600,width=1000,left=50,top=50,resizable=yes,titlebar=no,toolbar=no,menubar=no,scrollbar=no,location=no,status=no",true)
														setTimeout(function(){ documentsWin.document.title = '相关文献'; }, 100)
												}
											})
											$('#NodeMenu').menu('show', {    
												left: e.pageX+10,    
												top: e.pageY+5   
											}); 
									}, 
									onClick:function(node){
										if (node.checked){
											$(this).tree('uncheck',node.target)  
										}else{
											$(this).tree('check',node.target)  
										}
									},
									onCheck:function(node, checked){
										if (proSelectFlag==false){//多选模式
											if (checked){
											   if (!$(this).tree("isLeaf",node.target)) $(this).tree("expand",node.target);
											}
										}else{
											var nodes =$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('getChecked');
											if(nodes.length>1){ 
												for (var i=0;i<nodes.length;i++){
													var ids=nodes[i].id;
													if (ids==node.id) {
													
														continue
													}
													var node1 = $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('find',ids); 
													$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('uncheck',node1.target);
												}
										    }
										}
									},
									onLoadSuccess:function(node, data){
										var Roots=$(this).tree('getRoots');
										for (var j=0;j<Roots.length;j++){
											if (!$(this).tree("isLeaf",Roots[j].target)) $(this).tree("collapseAll",Roots[j].target);
										}
										
										for (var j=0;j<Roots.length;j++){
												if (!$(this).tree("isLeaf",Roots[j].target)) $(this).tree("expand",Roots[j].target);
										}
										//去掉treegrid结点前面的文件及文件夹小图标
										//$("#"+childId+"_T_"+treeNode+".tree-icon,#"+childId+"_T_"+treeNode+" .tree-file").removeClass("tree-icon tree-file");
										//$("#"+childId+"_T_"+treeNode+" .tree-icon,#"+childId+"_T_"+treeNode+" .tree-folder").removeClass("tree-icon tree-folder tree-folder-open tree-folder-closed"); 
									}
								})
						 	}
					}
			 })
		}
		
		
		
		
		
		/** 
 * 1）扩展jquery hisui tree的节点检索方法。使用方法如下： 
 * $("#treeId").tree("search", searchText);   
 * 其中，treeId为hisui tree的根UL元素的ID，searchText为检索的文本。 
 * 如果searchText为空或""，将恢复展示所有节点为正常状态 
 */ 
	$.extend($.fn.tree.methods, {  
        /** 
         * 扩展hisui tree的搜索方法 
         * @param tree hisui tree的根DOM节点(UL节点)的jQuery对象 
         * @param searchText 检索的文本 
         * @param this-context hisui tree的tree对象  trids+"^"+SearchText
         */  
        search: function(jqTree, str) {
	        var trids=str.split("^")[0];
	        var searchText=str.split("^")[1];
            //hisui tree的tree对象。可以通过tree.methodName(jqTree)方式调用hisui tree的方法  
            var tree = this;  
            //获取所有的树节点  
            var nodeList = getAllNodes(jqTree, tree);  
            //如果没有搜索条件，则展示所有树节点  
            searchText = $.trim(searchText);  
            /*if (searchText == "") {  
                for (var i=0; i<nodeList.length; i++) {  
                    $(".tree-node-targeted", nodeList[i].target).removeClass("tree-node-targeted");  
                    $(nodeList[i].target).show(); 
                    tree.collapse(jqTree, nodeList[i].target); 
                }  
                //展开已选择的节点（如果之前选择了）  
                var selectedNode = tree.getChecked(jqTree);  
                if (selectedNode) { 
                	for (var i=0;i<selectedNode.length;i++){
	                	 tree.expandTo(jqTree, selectedNode[i].target);  //
	                }
                }
                return;  
            } **/
            //搜索匹配的节点并高亮显示  
            var matchedNodeList = [];  
            if (nodeList && nodeList.length>0) {  
                var node = null;  
                for (var i=0; i<nodeList.length; i++) {  
                    node = nodeList[i];  
                    if (isMatch(searchText, node.text)) {  
                        //matchedNodeList.push(node);  
                        var text=node.text.split("<span class='hidecls'>")[0];
                    	//20180317bygss 鼠标悬浮显示备注
                        var remark=node.text.split("^")[3].split("</span>")[0]
                        /*if (remark!=""){
                        	CacheDiagProperty[trids+"#"+node["id"]]='<span class="hisui-tooltip" title="'+remark+'">'+text+'</span>' //text; //cache
                        }else{
                        	CacheDiagProperty[trids+"#"+node["id"]]=text; //cache
                        }*/
                        CacheDiagProperty[trids+"#"+node["id"]]=text; //cache

                        if (remark!=""){
                        	CacheDiagPropertyNote[trids+"#"+node["id"]]=remark; //cache
                        }
                    } 
                }  
                  
                //隐藏所有节点  
                /*for (var i=0; i<nodeList.length; i++) {  
                    $(".tree-node-targeted", nodeList[i].target).removeClass("tree-node-targeted");  
                    $(nodeList[i].target).hide();  
                }             
                //折叠所有节点  
                tree.collapseAll(jqTree);  
                //展示所有匹配的节点以及父节点              
                for (var i=0; i<matchedNodeList.length; i++) {  
                    showMatchedNode(jqTree, tree, matchedNodeList[i]);  
                } */ 
            }      
        },  
        /** 
         * 展示节点的子节点（子节点有可能在搜索的过程中被隐藏了） 
         * @param node hisui tree节点 
         */  
        showChildren: function(jqTree, node) {  
            //hisui tree的tree对象。可以通过tree.methodName(jqTree)方式调用hisui tree的方法  
            var tree = this;  
              
            //展示子节点  
            if (!tree.isLeaf(jqTree, node.target)) {  
                var children = tree.getChildren(jqTree, node.target);  
                if (children && children.length>0) {  
                    for (var i=0; i<children.length; i++) {  
                        if ($(children[i].target).is(":hidden")) {  
                            $(children[i].target).show();  
                        }  
                    }  
                }  
            }     
        },  
        /** 
         * 将滚动条滚动到指定的节点位置，使该节点可见（如果有滚动条才滚动，没有滚动条就不滚动） 
         * @param param { 
         *    treeContainer: hisui tree的容器（即存在滚动条的树容器）。如果为null，则取hisui tree的根UL节点的父节点。 
         *    targetNode:  将要滚动到的hisui tree节点。如果targetNode为空，则默认滚动到当前已选中的节点，如果没有选中的节点，则不滚动 
         * }  
         */  
        scrollTo: function(jqTree, param) {  
            //hisui tree的tree对象。可以通过tree.methodName(jqTree)方式调用hisui tree的方法  
            var tree = this;  
              
            //如果node为空，则获取当前选中的node  
            var targetNode = param && param.targetNode ? param.targetNode : tree.getSelected(jqTree);  
              
            if (targetNode != null) {  
                //判断节点是否在可视区域                 
                var root = tree.getRoot(jqTree);  
                var $targetNode = $(targetNode.target);  
                var container = param && param.treeContainer ? param.treeContainer : jqTree.parent();  
                var containerH = container.height();  
                var nodeOffsetHeight = $targetNode.offset().top - container.offset().top;  
                if (nodeOffsetHeight > (containerH - 30)) {  
                    var scrollHeight = container.scrollTop() + nodeOffsetHeight - containerH + 30;  
                    container.scrollTop(scrollHeight);  
                }                             
            }  
        }  
    });  
    /** 
     * 展示搜索匹配的节点 
     */  
    function showMatchedNode(jqTree, tree, node) {  
        //展示所有父节点  
        $(node.target).show();  
        //return false;
        $(".tree-title", node.target).addClass("tree-node-targeted");  
        var pNode = node;  
        while ((pNode = tree.getParent(jqTree, pNode.target))) {  
            $(pNode.target).show();               
        }  
        //展开到该节点  
        tree.expandTo(jqTree, node.target);  
        //如果是非叶子节点，需折叠该节点的所有子节点  
        if (!tree.isLeaf(jqTree, node.target)) {  
            tree.collapse(jqTree, node.target);  
        }  
    }      
    /** 
     * 判断searchText是否与targetText匹配 
     * @param searchText 检索的文本 
     * @param targetText 目标文本 
     * @return true-检索的文本与目标文本匹配；否则为false. 
     */  
    function isMatch(searchText, targetText) {
	    searchText=searchText.toUpperCase() ;
    	var text=targetText.split("<span class='hidecls'>")[0];
    	var text2=targetText.split("<span class='hidecls'>")[1];
    	if (text2!=""){
	    	var tmpsearchtext=text2.split("</span>")[0];
			var searchCode=tmpsearchtext.split("^")[1]; //检索码
			var othername=tmpsearchtext.split("^")[0]; //别名
			var displayname=tmpsearchtext.split("^")[2]; //展示名
			
			return $.trim(text)!="" && (text.toUpperCase().indexOf(searchText)!=-1 || searchCode.toUpperCase().indexOf(searchText)!=-1 ||othername.toUpperCase().indexOf(searchText)!=-1 || displayname.toUpperCase().indexOf(searchText)!=-1)  
	    }else{
		    return $.trim(text)!="" && text.indexOf(searchText)!=-1;  
		}
    }  
    /** 
     * 获取hisui tree的所有node节点 
     */  
    function getAllNodes(jqTree, tree) {  
        var allNodeList = jqTree.data("allNodeList");  
        if (!allNodeList) {  
            var roots = tree.getRoots(jqTree);  
            allNodeList = getChildNodeList(jqTree, tree, roots);  
            jqTree.data("allNodeList", allNodeList);  
        }  
        return allNodeList;  
    }  
    /** 
     * 定义获取hisui tree的子节点的递归算法 
     */  
    function getChildNodeList(jqTree, tree, nodes) {  
        var childNodeList = [];  
        if (nodes && nodes.length>0) {             
            var node = null;  
            for (var i=0; i<nodes.length; i++) {  
                node = nodes[i];  
                childNodeList.push(node);  
                if (!tree.isLeaf(jqTree, node.target)) {  
                    var children = tree.getChildren(jqTree, node.target);  
                    childNodeList = childNodeList.concat(getChildNodeList(jqTree, tree, children));  
                }  
            }  
        }  
        return childNodeList;  
    }  

    
    
    
    
    // 扩展datagrid:动态添加删除editor  
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

}
$(init);