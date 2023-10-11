/**   
 * @Title: 医为百科 
 * @Description:查看知识
 * @author: 程和贵
 * @Created:  2018-05-18 
 * @Edit:  2020-09-27 石萧伟   
 */

$(function () {
	$("#div-img").hide();

	$.fn.datagrid.defaults.onHeaderContextMenu = function(){};   //屏蔽表头右键功能
	$.fn.treegrid.defaults.onHeaderContextMenu =  function(){}; 
	//var termdr=GetURLParams("id");
	//var base= GetURLParams("base");
	var count=0;  //记录目录条数
	if(termdr==null || termdr==""){
		 termdr="1650775";  //默认展示 肺癌
	}
	if(base==null || base==""){
		base=5;
	 }
	 var scrollindex = 0;//页面加载时跳转用
	///chenying
	//var termdrDesc=$.m({EncryItemName:upws0,id:termdr},function(){}) 
	var termdrDesc=$.m({ClassName:"web.DHCBL.MKB.MKBTerm",MethodName:"GetDesc",id:termdr},false);
	String.addSpace=function(str){
			 return str.split("").join(" ");
	};
	termdrDesc = String.addSpace(termdrDesc);
	 $.m({
		 ClassName:"web.DHCBL.MKB.MKBEncyclopedia",
		 MethodName:"GetTermInfo",
		 id:termdr
	 },function(textData){
		var  textData= eval('('+textData+')');  
		//console.log(textData)
		//基本信息
		$("#head_h1").html(termdrDesc+"<p style='text-align:left;margin-left:17px;font-weight:bold'>基本信息：</p>"+"<p style='text-indent:2em;text-align: left;margin-left:17px width:"+document.body.clientWidth*0.9+"px' id='head_h11'>"+textData.MKBTNote+"</p><table id='baseinfotable' style='margin:15px 17px'><tbody><tr><td class='tdname'>全称:</td><td class='tdvalue'>"+textData.MKBTDesc+"</td><td class='tdname'>别名:</td><td class='tdvalue'>"+textData.MKBTOther.split("||")[0]+"</td><td class='tdname'>所属知识:</td><td class='tdvalue'>"+textData.MKBTBaseDR+"</td></tr></tbody></table>");
		//只有新型肺炎展示预览20200206
		if(termdr=="1650775"){
			   $("#head_h1").after("<div id='linktab' class='changetab' style='height:50px;background-color:#f4f6f5;width:95%;border-bottom:#40a2de solid 1px;margin-left:50px'><a class='changetabs select'><i><span>知识概况<span></i></a><a class='changetabs'><i><span id='docnum'></span></i></a><a class='changetabs'><i><span>预览<span></i></a></div>")
		}else{
				  $("#head_h1").after("<div id='linktab' class='changetab' style='height:50px;background-color:#f4f6f5;width:95%;border-bottom:#40a2de solid 1px;margin-left:50px'><a class='changetabs select'><i><span>知识概况<span></i></a><a class='changetabs'><i><span id='docnum'></span></i></a></div>")		   
		}
		$("#changeview").click(function(e){
			var _height=document.documentElement.clientHeight || document.body.clientHeight;
			var _width = document.documentElement.clientWidth || document.body.clientWidth;
			$("#iframeview").css("height",_height-20);
			$("#iframeview").css("width",_width);
			if( $("#iframeview").css("display")=="none"){
				 $("#head_h").css("display","none");
				 $("#iframeview").css("display","block");
				 $("#directory-navbefore").css('display','none');
				 var url="dhc.bdp.mkb.mkbdiagbrowser.csp?termdr="+termdr+"&base="+base
				 if ('undefined'!==typeof websys_getMWToken){
		            url += "&MWToken="+websys_getMWToken()
		        }
				 $("#iframeview").attr("src",url)
				 $("#changeview").css("padding-right","8px");
 
				 //$("body").css("padding","0");
			}else{
				 $("#iframeview").css("display","none");
				 $("#head_h").css("display","block");
				 $("#changeview").css("padding-right","0");
				 $("#directory-navbefore").css('display','block');
				 //$("body").css("padding","0 10px 0 10px")
			}
		})
		$(".changetabs").click(function(e){
			  if(!$(this).hasClass("select")){
				  $(this).addClass('select');
				  $(this).siblings().removeClass('select');
				  if($(".select").text()!="知识概况"&&$(".select").text()!="预览"){
					 $("#infoflag").val("doc")
					$(".displaycontent").css('display','none');
					$("#countheight").css('display','none');
					$("#directory-navbefore").css('display','none');
					$("#directory-navbefore").remove();
					$("#relationdoc").css('display','block');
					if(count==0){
						$("#nulldiv").css("display","none");
					 }
					 $("#previewdoc").css("display","none");
					 $('#doclay').panel('resize')
				  }else if($(".select").text()=="知识概况"){
					 setTimeout(function(){directoryNav = new DirectoryNav($("h2,h3"),{
						 scrollTopBorder:300 //滚动条距离顶部多少的时候显示导航，如果为0，则一直显示
					 });},1000);  //需要加延时 解决获得高度不准问题
					 $("#directory-navbefore").css('display','block');
					 $(".displaycontent").css('display','block');
					 $("#countheight").css('display','block'); 
					 if(count==0){
						  $("#countheight").css("display","none")
						  $("#nulldiv").css("display","block")
					 }
					 $("#relationdoc").css('display','none');
					 $("#previewdoc").css("display","none");
				  }else{
						  $("#previewdoc").css("display","block");
						  $("#relationdoc").css('display','none');
						  $("#directory-navbefore").css('display','none');
						 $(".displaycontent").css('display','none');
						 $("#countheight").css('display','none'); 
							if(count==0){
								$("#nulldiv").css("display","none");
								
						 }
				  }
			  }
		  })        
	 })
	 //展示医为百科首页的所有属性及内容
	setTimeout(function(){  //加延迟解决首页属性标题栏出不来的问题
		$.cm({
			ClassName: "web.DHCBL.MKB.MKBEncyclopedia",
			QueryName: "GetList",
			termdr: termdr
		}, function (jsonData) {
			console.log(jsonData)
			if(jsonData.rows.length == 0){
				//$("#div-img").css("display", "block")
				$("#div-img").show();
			}
			var deschtml = "";
			var iframhtml = ""
			var ahtml = "";
			for (var j = 0, len = jsonData.rows.length; j < len; j++) {
				var MKBTPDesc = jsonData.rows[j].MKBTPDesc;
				if (MKBTPDesc == "") { 
					continue;
				}
				var MKBTPRowId = jsonData.rows[j].MKBTPRowId;
				if (MKBTPRowId == proid) {
					scrollindex = j;
				}
				var MKBTPDesc1 = jsonData.rows[j].MKBTPDesc;
				if (MKBTPDesc.length > 8) {
					MKBTPDesc = MKBTPDesc.substring(0, 6) + "...";
				}// 知识点下拉框
 
				var type = jsonData.rows[j].MKBTPType;
				 
				//if (termdr!=1650775){
				//自动生成属性标题及内容框部分
				deschtml = "<div class='displaycontent' style='display:block;'>" +
					"<h2 id='h" + j + "'>" +
					"<div style='border-left:#4F9CEE solid 12px;height:28px;width:1%;display:block;margin-left:0;float:left;display:inline-block;'>" +
					"</div>" +
					"<div style='margin:10px 0 0 35px;width:83%;height:28px;'>" +
					"<div style='padding-right:15px;font-size:16px;font-weight:400;background-color:#FFFFFF;float:left;width:auto;display:inline-block;'>" + MKBTPDesc1 + "" +
					"</div>" +
					"</div>" +
					"<div style='width:20px;margin-right:14%;margin-top:-22px;height:20px;background-color:#FFFFFF'><a href='javascript:void(0)' class='commit hisui-tooltip'><img src='../scripts/bdp/Framework/icons/mkb/commitkno.png' onclick=commitkno('" + type + "'," + j + "," + termdr + "," + MKBTPRowId + ")></img></a>" +
					"</div>" +
					"</h2>" +
					"<div style='width:78.8%;border:#ccc solid 0.5px;margin-left:50px'>" +
					"</div>" +
					"<div id='div" + j + "' style='height:auto;margin-top:10px;margin-left:50px;width:78.8%;border:1px solid #C0C0C0;border-radius:4px'>" +
					"</div>" +
					"</div>";
				 
				//右下角目录
				//if(jsonData.rows[j].MKBTBPWikiShow == "" || jsonData.rows[j].MKBTBPWikiShow == "details"){
				ahtml = ahtml + "<li style='float:left;padding:2px 5px 2px 5px;width:16%'>" +
					"<a  href='javascript:void(0)' id='ah" + j + "' onclick=moreCount('" + "h" + j + "')>" + MKBTPDesc + "</a>" +
					"</li>";
 
				//}
			 
				 
				var propertyid = MKBTPRowId;
				var propertyName = jsonData.rows[j].MKBTPName;
				if (propertyName == "") {
					propertyName = MKBTPDesc
				}
				$("#head_h").append(deschtml);
				$(".commit").tooltip({
					content: '<span>知识提交</span>',
					position: 'left', //top , right, bottom, left
					onShow: function () {
						$(this).tooltip('tip').css({
							backgroundColor: '#666',
							borderColor: '#666'
						});
					}
				})
				//获取扩展属性信息
				var extendInfo = $.m({ ClassName: 'web.DHCBL.MKB.MKBTermProDetail', MethodName: 'getExtendInfo', property: propertyid }, false);
				var extend = extendInfo.split("[A]")
				var propertyName = extend[0];  //主列名
				var extendChild = extend[1];  //扩展属性child串
				var extendTitle = extend[2];  //扩展属性名串
				var extendType = extend[3];    //扩展属性格式串 
				var extendConfig = extend[4];    //扩展属性配置项串
				//树形和列表型属性的列
				var columns = [[
					{ field: 'id', title: 'id', width: 80, hidden: true, resizable: false },
					{
						field: 'MKBTPDDesc', title: propertyName, resizable: false, width: 200/*,
									 formatter: function(value,row,index){
										 return "<span style='white-space:nowrap;'>"+value+"</span>"
									 }*/
					},
					{
						field: 'MKBTPDRemark', title: '详情', width: 150, resizable: false,
						formatter: function(value,row,index){
							if (value.indexOf('  ') > -1) {
								  value = value.replace(/\s+/g,"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp");
							 }
						   return value
					   }

					},
					{ field: 'MKBTPDLastLevel', title: '上级分类', width: 100, resizable: false, hidden: true },
					{ field: 'MKBTPDSequence', title: '顺序', width: 100, resizable: false, hidden: true }
				]];
				 
				if (extendChild != "")   //如果有扩展属性，则自动生成列  
				{
					var colsField = extendChild.split("[N]");
					var colsHead = extendTitle.split("[N]");
					var typeStr = extendType.split("[N]");
					var configStr = extendConfig.split("[N]");
					for (var i = 0; i < colsField.length; i++) {
						//添加列 方法2
						var column = {};
						column["title"] = colsHead[i];
						column["field"] = 'Extend' + colsField[i];
						column["width"] = 150;
						column["sortable"] = false;
						column["resizable"] = false;
						columns[0].push(column);
					}
				}
				if (type == "L") {
					iframhtml = '<table id="llist' + j + '" border="false" ></table>'
					$("#div" + j).append(iframhtml);
					var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetMyList";
					//列表datagrid
					var mygrid = $HUI.datagrid("#llist" + j, {
						url: QUERY_ACTION_URL + "&property=" + propertyid + "&rows=9999999&page=1",
						columns: columns,
						pagination: false,   //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
						singleSelect: true,
						idField: 'MKBTPDRowId',
						autoRowHeight: true,  //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能。
						nowrap: false,  //设置为 true，则把数据显示在一行里。设置为 true 可提高加载性能。
						autoSizeColumn: true, //调整列的宽度以适应内容。
						fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
						scrollbarSize: 0,
						onLoadSuccess: function (data) {
							//console.log(data)
							$(this).prev().find('div.datagrid-body').prop('scrollTop', 0);
 
						}
 
					});
 
				}
				else if (type == "T") {
					iframhtml = "<table border='false' id='treegrid" + j + "'></table>"
					$("#div" + j).append(iframhtml);
					var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBEncyclopedia&pClassMethod=GetJsonList";
					//列表datagrid
					var mygrid = $HUI.treegrid("#treegrid" + j, {
						url: QUERY_ACTION_URL + "&property=" + propertyid,
						columns: columns,
						idField: 'id',
						// lines:true,
						autoRowHeight: true,
						nowrap: false,
						treeField: 'MKBTPDDesc',  //树形列表必须定义 'treeField' 属性，指明哪个字段作为树节点。
						autoSizeColumn: true,
						animate: false,     //是否树展开折叠的动画效果
						fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
						remoteSort: false, //定义是否从服务器排序数据。true
						scrollbarSize: 0,
						onLoadSuccess: function (data) {
							$(this).prev().find('div.datagrid-body').prop('scrollTop', 0);
 
						}
					});
				}
				else if ((type == "TA") || (type == "TX") || (type == "C") || (type == "CB") || (type == "R") || (type == "F") || (type == "SD") || (type == "ETX")) {
					var tmpdesc = $.m({ ClassName: 'web.DHCBL.MKB.MKBEncyclopedia', MethodName: 'GetDetailDesc', id: propertyid, type: type }, false);
					//iframhtml = "<span>" + tmpdesc + "</span>";
					if(tmpdesc.indexOf("text-indent: 2em;")>-1){
						tmpdesc = tmpdesc.replace(/<p style=\\"text-indent: 2em;\\">/g, '<p style=\\"text-indent: 2em;\\">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp')
						console.log(tmpdesc)
					}
					$("#div" + j).append(tmpdesc);
				}
				else if (type == "P") {
					iframhtml = '<table data-options="fit:false" id="plist' + j + '" border="false" ></table>'
					$("#div" + j).append(iframhtml);
					//datagrid列
					var pcolumns = [[
						{ field: 'MKBTPRowId', title: 'RowId', width: 80, hidden: true, resizable: false },
						{ field: 'MKBTPDesc', title: '属性', width: 150, resizable: false },
						{ field: 'MKBTPType', title: '格式', width: 150, resizable: false, hidden: true },
						{
							field: 'MKBTPShowType', title: '展示格式', width: 150, resizable: false,
							formatter: function (v, row, index) {
								if (v == "C") { return "下拉框" }
								if (v == "T") { return "下拉树" }
								if (v == "TX") { return "文本框" }
								if (v == "TA") { return "多行文本框" }
								if (v == "CB") { return "单选框" }
								if (v == "CG") { return "复选框" }
								if (v == "MC") { return "多选下拉框" }
							}
						},
						{
							field: 'MKBTPTreeNode', title: '定义节点', width: 150, resizable: false,
							formatter: function (v, row, index) {
								if (v) {
									var showvalue = $.m({ ClassName: "web.DHCBL.MKB.MKBTermProDetail", MethodName: "GetDesc", id: v }, false);
									return showvalue
								} else {
									return "暂无";
								}
							}
						},
						{
							field: 'MKBTPChoice', title: '单选/复选', width: 150, resizable: false,
							formatter: function (v, row, index) {
								if (v == "D") {
									return "多选"
								}
								else {
									return "单选"
								}
							}
							 
						},
						{
							field: 'MKBTPRequired', title: '是否必填', width: 150, sortable: true,
							formatter: function (v, row, index) {
								if (v == "Y") {
									return "必填"
								}
								else {
									return "不必填"
								}
							}
						}
					]];
					//列表datagrid
					//console.log(columns)
					$HUI.datagrid("#plist" + j, {
						url: $URL,
						queryParams: {
							ClassName: "web.DHCBL.MKB.MKBTermProDetail",
							QueryName: "GetSelPropertyList",
							property: propertyid
						},
						columns: pcolumns,
						pagination: false,   //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
						singleSelect: true,
						idField: 'MKBTPRowId',
						rownumbers: false,    //设置为 true，则显示带有行号的列。
						fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
						scrollbarSize: 0,
						onLoadSuccess: function (data) {
							//console.log(data)
							$(this).prev().find('div.datagrid-body').prop('scrollTop', 0);
 
						}
					});
				}
				else if (type == "S") {
					var configListOrTree = $.m({ ClassName: "web.DHCBL.MKB.MKBTermProDetail", MethodName: "GetProListOrTree", property: propertyid }, false);  //引用术语是树形还是列表型
					if (configListOrTree == "T") {
						iframhtml = '<table id="treeterm' + j + '" data-options="fit:false,border:false"></table>';
						$("#div" + j).append(iframhtml);
						$HUI.tree('#treeterm' + j, {
							url: "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetDocSourseTreeJson&property=" + propertyid,
							lines: true,  //树节点之间显示线条
							autoSizeColumn: true,
							id: 'id',//这里的id其实是所选行的idField列的值
							cascadeCheck: true,  //是否级联检查。默认true  菜单特殊，不级联操作     
							animate: false,   //是否树展开折叠的动画效果 
							onExpand: function (node) {
							},
							onCollapse: function (node) {
							}
						});
					}
					else {
						iframhtml = '<table id="listterm' + j + '" data-options="fit:false,border:false"></table>';
						$("#div" + j).append(iframhtml);
						//datagrid列
						var columns = [[
							{ field: 'MKBTPDRowId', title: '属性内容表id', width: 80, hidden: true, resizable: false },
							{
								field: 'MKBTPDSequence', title: '顺序', width: 150, sortable: true, hidden: true, resizable: false,
								sorter: function (a, b) {
									if (a.length > b.length) return 1;
									else if (a.length < b.length) return -1;
									else if (a > b) return 1;
									else return -1;
								}
							},
							{ field: 'MKBTRowId', title: 'RowId', width: 80, hidden: true, resizable: false },
							{ field: 'MKBTDesc', title: '描述', width: 150, resizable: false },
							{ field: 'MKBTCode', title: '代码', width: 150, resizable: false }
						]];
						//列表datagrid
						var mygrid = $HUI.datagrid("#listterm" + j, {
							url: $URL,
							queryParams: {
								ClassName: "web.DHCBL.MKB.MKBTermProDetail",
								QueryName: "GetSellistTermList",
								property: propertyid
							},
							columns: columns,
							pagination: false,   //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
							idField: 'MKBTRowId',
							rownumbers: true,    //设置为 true，则显示带有行号的列。
							fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
							remoteSort: false,  //定义是否从服务器排序数据。true
							sortName: 'MKBTPDSequence',
							sortOrder: 'asc',
							scrollbarSize: 0
						});
					}
				}
				else if (type == "SS") {//---引用起始节点---石萧伟
					iframhtml = '<table id="streeterm' + j + '" data-options="fit:false,border:false"></table>';
					$("#div" + j).append(iframhtml);
					$HUI.tree('#streeterm' + j, {
						url: "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetSourseSingleTermJson&property=" + propertyid,
						lines: true,  //树节点之间显示线条
						autoSizeColumn: false,
						checkbox: false,
						id: 'id',//这里的id其实是所选行的idField列的值
						cascadeCheck: true,  //是否级联检查。默认true  菜单特殊，不级联操作		
						animate: false,   //是否树展开折叠的动画效果
						onLoadSuccess: function (data) {
						},
						onBeforeExpand: function (node) {
							$(this).tree('expandFirstChildNodes', node)
						},
						onContextMenu: function (e, node) {
							e.preventDefault();
						}
							 
					});
				}
				else {
					$("#div" + j).append("");
				}
				 
				count++;  //记录属性个数
				if (j == jsonData.rows.length-1) { 
					var emptyhtml = "<div style='width:auto;height:1000px'></div>"
					$("#head_h").append(emptyhtml);
				}
			}
		 
			//$("#head_h").append(deschtml);
			moreCount = function (id) {
				setTimeout(function () { $('html,body').animate({ scrollTop: $("#" + id).offset().top }, 500); }, 100) //滚动效果
				//document.getElementById("more").scrollIntoView(true)  //跳转效果
			}
			$("#linktab").after("<div id='countheight' style='display:block;margin-top:10px;margin-left:50px;width:95%;overflow:hidden;border:1px solid #C0C0C0;border-radius:4px'><div style='float:left;width:186px;height:170px;background-color:#f4f6f5'><div id='more' style='font-size:24px;font-weight:400;text-align:center;line-height:170px;border-right:1px solid #C0C0C0'>目录</div></div><div style='min-height:35px;padding-left:20px;float:left;width:75%'><ul style='list-style:none;padding:10px;'>" + ahtml + "</ul></div></div>");
			if (count == 0) {
				$("#countheight").css("display", "none")
				$("#countheight").after("<div id='nulldiv' style='height:100px'></div>")
				$("#div-img").css("display", "block")
			}
			// $("#countheight").css('height', (Math.ceil(count/5)*30+30)+'px');
			//实例化 一定要在动态添加元素后 立刻实例化 否则遍历不到新添加的元素
			setTimeout(function () {
				directoryNav = new DirectoryNav($("h2,h3"), {
					scrollTopBorder: 300 //滚动条距离顶部多少的时候显示导航，如果为0，则一直显示
				});
 
			}, 1000);  //需要加延时 解决获得高度不准问题
			setTimeout(function () { 
			 if(proid!=""&&proid!=undefined){
				 moreCount('h'+scrollindex);
			 }
		 },100)	
		});
	 },100); 
   
	 ///**************************************知识提交部分开始**************************/
	 var InitTermBox=function()
	 {
		 //判断是列表型还是树形
		 var basetype= $.m({ClassName:"web.DHCBL.MKB.MKBTerm",MethodName:"GetBaseTypeByID",ID:base},false);
		 if(basetype=="L")
		 {
			 $("#termbox").combobox({
				 //url: $URL+"?ClassName=web.DHCBL.MKB.MKBTerm&QueryName=GetList&ResultSetType=array&base="+base, 
				 url: $URL+"?ClassName=web.DHCBL.MKB.MKBKnoExpression&QueryName=GetListTerm&ResultSetType=array&base="+base,							
				 valueField: 'MKBTRowId',    
				 textField: 'MKBTDesc',
				 onSelect: function(rec){  
					 var url = $URL+"?ClassName=web.DHCBL.MKB.MKBTermProperty&QueryName=GetList&ResultSetType=array&termdr="+rec.MKBTRowId;
					 $('#probox').combobox({url:url});  
					 CreateDataPanel("","");						
				 },
				 keyHandler:{
					 enter:function(){
						 var desc=$.trim($('#termbox').combobox('getText'));
						 $('#termbox').combobox('reload',$URL+"?ClassName=web.DHCBL.MKB.MKBTerm&QueryName=GetList&ResultSetType=array&base="+base+"&desc="+encodeURI(desc));
						 $('#termbox').combobox("setValue",desc);
					 }
					
				 }
 
			 })
		   }
		   else
		   {
			 $HUI.combotree('#termbox',{
				 url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmb&base="+base,
				 onSelect: function(node){  
					 var url = $URL+"?ClassName=web.DHCBL.MKB.MKBTermProperty&QueryName=GetList&ResultSetType=array&termdr="+node.id;
					 $('#probox').combobox({url:url});   
					 CreateDataPanel("",""); 
				 }
			 });
		   }
		 $("#probox").combobox({
			 valueField:'MKBTPRowId',
			 textField:'MKBTPDesc',
			 onSelect:function(rec){  
				 CreateDataPanel(rec.MKBTPType,rec.MKBTPRowId);
			 },
			 keyHandler:{
				 enter:function(){
					 var desc=$.trim($('#probox').combobox('getText'));
					 var termdr= $('#termbox').combobox("getValue");
					 $('#probox').combobox('reload',$URL+"?ClassName=web.DHCBL.MKB.MKBTermProperty&QueryName=GetList&ResultSetType=array&termdr="+termdr+"&desc="+encodeURI(desc));
					 $('#probox').combobox("setValue",desc);
				 }
				
			 }
		 })
	 }
	 //创建表单属性内容面板
	 var CreateDataPanel= function(type,proid){
		 $("#MKBKMDetailI").val("");
		 $("#MKBKMDetailI2").val("");
		 if(type=="L")
		 {
			 //列表型
			 TypeOfList(proid);
		 }else if(type=="T"){
			 //树形
			 TypeOfTree(proid);
		 }else if((type=="TA")||(type=="TX")||(type=="C")||(type=="CB")||(type=="R")||(type=="F")||(type=="SD")){
			 TypeOfTxy(proid,type);
		 }else if(type=="P"){
			 TypeOfPro(proid);
		 }else if(type=="S"){
			 //引用术语格式属性内容维护模块
			TypeOfTerm(proid);
		 }else if(type == "SS"){
			 TypeOfSingle(proid);
		 }else{
			 $("#detail").empty()
		 }
	 }
	 //表单----引用起始节点----石萧伟
	 var TypeOfSingle = function(proid){
		 var datagridHtml = "<table data-options='fit:true,border:false' id='detailGridTreeSingle'></table>"
		 $("#detail").empty()
		 $("#detail").append(datagridHtml);
		 //var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetSourseSingleTermJson";	
		 //列表datagrid
		 $HUI.tree('#detailGridTreeSingle',{
			 url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetSourseSingleTermJson&property="+proid,
			 lines:true,  //树节点之间显示线条
			 autoSizeColumn:false,
			 checkbox:false,
			 id:'id',//这里的id其实是所选行的idField列的值
			 cascadeCheck:true,  //是否级联检查。默认true  菜单特殊，不级联操作		
			 animate:false,   //是否树展开折叠的动画效果
			 scrollbarSize:0,
			 onLoadSuccess:function(data){
			 },
			 onBeforeExpand:function(node){
				 $(this).tree('expandFirstChildNodes',node)
			 },
			 onContextMenu: function(e, node){
				 e.preventDefault();		
			 }
				 
		 });
	 }			
	 // 生成树形的columns
	 var MakeTreeExtendColums=function(proid){
		  //获取扩展属性信息 				 
		 ///var extendInfo=$.m({EncryItemName:upws1,property:proid},function(){}) 
		 var extendInfo=$.m({ClassName:'web.DHCBL.MKB.MKBTermProDetail',MethodName:'getExtendInfo',property:proid},false);
		 var extend=extendInfo.split("[A]")
		 var propertyName = extend[0];  //主列名
		 var extendChild =extend[1];  //扩展属性child串
		 var extendTitle =extend[2];  //扩展属性名串
		 var extendType =extend[3];    //扩展属性格式串
		 var extendConfig =extend[4];    //扩展属性配置项串
 
		 //datagrid列
		 var columns =[[  
			{field:'id',title:'id',width:80,sortable:true,hidden:true},
			{field:'MKBTPDDesc',title:propertyName,width:150,sortable:true},
			 {
				 field: 'MKBTPDRemark', title: '详情', width: 150, sortable: true,
				 formatter: function(value,row,index){
					if (value.indexOf('  ') > -1) {
						  value = value.replace(/\s+/g,"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp");
					 }
				   return value
			   }

			 },
			{field:'MKBTPDLastLevel',title:'上级分类',width:150,sortable:true,hidden:true},
			{field:'MKBTPDSequence',title:'顺序',width:150,sortable:true,hidden:true}
		]];
		 
		 if (extendChild!="" && termdr!="1650775")   //如果有扩展属性，则自动生成列 新型肺炎只显示备注20200206
		 {
			 var colsField = extendChild.split("[N]"); 
			 var colsHead = extendTitle.split("[N]"); 
			 var typeStr = extendType.split("[N]"); 
			 var configStr = extendConfig.split("[N]"); 
			 for (var i = 0; i <colsField.length; i++) {
				 var column={};  
				 column["title"]=colsHead[i];  
				 column["field"]='Extend'+colsField[i];  
				 column["width"]=150;  
				 column["sortable"]=true; 
				 columns[0].push(column)
			 }
		 }
		 return columns;
	 }
	 // 表单---属性内容面板-树形
	 var TypeOfTree = function(proid){
		 var datagridHtml = "<table data-options='fit:true,border:false' id='detailGridTree'></table>"
		 $("#detail").empty()
		 $("#detail").append(datagridHtml);
		 var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetJsonList";
		 //列表datagrid
		 var columns=MakeTreeExtendColums(proid);
		 $("#detailGridTree").treegrid({
			 url:QUERY_ACTION_URL+"&property="+proid,
			 columns:columns,
			 idField: 'id',
			 checkbox:true,
			 scrollbarSize:0,
			 treeField:'MKBTPDDesc',  //树形列表必须定义 'treeField' 属性，指明哪个字段作为树节点。
			 //autoSizeColumn:true,
			 //animate:false,     //是否树展开折叠的动画效果
			 fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
			 remoteSort:false,  //定义是否从服务器排序数据。true
			 onCheckNode:function(){    //多选 
				 var selections = $("#detailGridTree").treegrid("getCheckedNodes");
				 var str=""
				 for (var i=0,len=selections.length;i<len;i++){
						 //$("#detailTreeWinGridGrid").treegrid("checkNode",selections[i].id)
						 if(str!=""){
							 str=str+"^"+ selections[i].id;
						 }else{
							 str=selections[i].id;
						 }   
					 }
					 $("#MKBKMDetailI").val(str)
					 var descstr = ""
					 for(var i=0,len=str.split("^").length;i<len;i++){
						 var desc=$.m({ClassName:"web.DHCBL.MKB.MKBTermProDetail",MethodName:"GetDesc",id:str.split("^")[i]},false);
						 if(descstr!="")
						 {
							 descstr=descstr+"^"+desc
						 }else{
							 descstr = desc
						 }
						 $("#MKBKMDetailI2").val(descstr)
					 }
					 
			 }
		 });
	 }
	 
	 // 生成列表的columns
	 var MakeListExtendColums =function(proid){
		   //获取扩展属性信息
		 var extendInfo=tkMakeServerCall('web.DHCBL.MKB.MKBTermProDetail','getExtendInfo',proid);
		 var extend=extendInfo.split("[A]")
		 var propertyName = extend[0];  //主列名
		 var extendChild =extend[1];  //扩展属性child串
		 var extendTitle =extend[2];  //扩展属性名串
		 var extendType =extend[3];    //扩展属性格式串
		 var extendConfig =extend[4];    //扩展属性配置项串
		 //datagrid列
		 var columns =[[ 
						 {field:'ck',checkbox:true},
						 {field:'MKBTPDRowId',title:'RowId',width:80,sortable:true,hidden:true},
						 {field:'MKBTPDDesc',title:propertyName,width:150,sortable:true},
						 {field:'MKBTPDRemark',title:'备注',width:150,sortable:true,
						 formatter: function(value, row, index) {
								 var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
								 return content;
							 }
						 },
						 {field:'MKBTPDSequence',title:'顺序',width:150,sortable:true,hidden:true,
							 sorter:function (a,b){  
								 if(a.length > b.length) return 1;
									 else if(a.length < b.length) return -1;
									 else if(a > b) return 1;
									 else return -1;
							 }
						 }
					 ]];
		 
		 if (extendChild!="")   //如果有扩展属性，则自动生成列
		 {
			 var colsField = extendChild.split("[N]"); 
			 var colsHead = extendTitle.split("[N]"); 
			 var typeStr = extendType.split("[N]"); 
			 var configStr = extendConfig.split("[N]"); 
			 //alert(configStr)
			 for (var i = 0; i <colsField.length; i++) {
				 var column={};  
				 column["title"]=colsHead[i];  
				 column["field"]='Extend'+colsField[i];  
				 column["width"]=150;  
				 column["sortable"]=true; 
				 columns[0].push(column);
	 
			 }
		 }
		 return columns;
	 }
	 //表单 ---列表型的 属性内容
	 var TypeOfList= function(proid){
		 var datagridHtml = "<table data-options='fit:true,border:false' id='detailGridList'></table>"; 
		 $("#detail").empty()
		 $("#detail").append(datagridHtml);
		 var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetMyList";
		 var columns =MakeListExtendColums(proid);
		 //列表datagrid
		 var mygrid = $HUI.datagrid("#detailGridList",{
			 bodyCls:'panel-header-gray',
			 url:QUERY_ACTION_URL+"&property="+proid+"&rows=9999999&page=1",
			 columns:columns,
			 pagination: false,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
			 singleSelect:false,
			 idField:'MKBTPDRowId', 
			 fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
			 remoteSort:false,  //定义是否从服务器排序数据。true
			 sortName : 'MKBTPDSequence',
			 sortOrder : 'asc',
			 //ctrlSelect:true,
			 //checkOnSelect: false,
			 //selectOnCheck: true,
			 //scrollbarSize:0,
			 //checkbox:true,
			 onCheck:function(){selectDetail()},
			 onUncheck:function(){selectDetail()},
				onLoadSuccess: function(data){
				 $('.mytooltip').tooltip({
					 trackMouse:true,
					 onShow:function(e){
						 $(this).tooltip('tip').css({
							 width:250 ,top:e.pageY+20,left:e.pageX-(250/2)
						 });
					 }
	 
				 });
			  } 
		 });
		 //设置分页属性
		 /*var mypagination = $('#detailGridList').datagrid("getPager");
			if (mypagination){
				$(mypagination).pagination({
				   showPageList:false,
				   displayMsg: ''
				});
			}*/
		 //多条选中行
		 var selectDetail=function(){
			 var selections = $('#detailGridList').datagrid('getChecked');
			 var str=""
			 for (var i=0,len=selections.length;i<len;i++){
			  //$("#detailListWinGrid").datagrid("selectRecord",selections[i].MKBTPDRowId); 
				 if(str!=""){
					 str=str+"^"+ selections[i].MKBTPDRowId;
				 }else{
					 str=selections[i].MKBTPDRowId;
				 } 
			
			 }
			 $("#MKBKMDetailI").val(str)
			 var descstr = ""
			 for(var i=0,len=str.split("^").length;i<len;i++){
				 var desc=$.m({ClassName:"web.DHCBL.MKB.MKBTermProDetail",MethodName:"GetDesc",id:str.split("^")[i]},false);
				 if(descstr!="")
				 {
					 descstr=descstr+"^"+desc
				 }else{
					 descstr = desc
				 }
				 $("#MKBKMDetailI2").val(descstr)
			 }            
		 }    
	 }
	 //表单---属性内容面板---文本,多行文本,下拉框,表单,单选,多选
	 // 均以文本展示
	 var TypeOfTxy = function(proid,type){
		 var tmpdesc =$.m({ClassName:'web.DHCBL.MKB.MKBEncyclopedia',MethodName:'GetDetailDesc',id:proid,type:type},false);
		 var datagridHtml="<span>"+tmpdesc+"</span>";
		 $("#detail").empty()
		 $("#detail").append(datagridHtml);
	 }
	 // 表单---属性内容面板---引用属性
	 var TypeOfPro =function(proid){
		 var datagridHtml='<table data-options="fit:false" id="dlist" border="false" ></table>'
		 $("#detail").empty();
		 $("#detail").append(datagridHtml); 
		  //datagrid列
		 var columns =[[   
			 {field:'MKBTPRowId',title:'RowId',width:80,hidden:true,resizable:false},
			 {field:'MKBTPDesc',title:'属性',width:150,resizable:false},
			 {field:'MKBTPType',title:'格式',width:150,resizable:false,hidden:true},
			 {field:'MKBTPShowType',title:'展示格式',width:150,resizable:false,
				 formatter:function(v,row,index){  
					 if(v=="C"){return "下拉框"}
					 if(v=="T"){return "下拉树"}
					 if(v=="TX"){return "文本框"}
					 if(v=="TA"){return "多行文本框"}
					 if(v=="CB"){return "单选框"}
					 if(v=="CG"){return "复选框"}
					 if(v=="MC"){return "多选下拉框"}                         
				 }
			 },
			 {field:'MKBTPTreeNode',title:'定义节点',width:150,resizable:false,
				 formatter:function(v,row,index){ 
					 var showvalue=$.m({ClassName:"web.DHCBL.MKB.MKBTermProDetail",MethodName:"GetDesc",id:v},false);
					 return showvalue 
				 }
			 },
			 {field:'MKBTPChoice',title:'单选/复选',width:150,resizable:false,
				 formatter:function(v,row,index){  
					 if(v=="D"){
						 return "多选"
					 }
					 else{
						 return "单选"
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
				 }
			 }
		 ]]; 
		 //列表datagrid
		 //console.log(columns)
		$HUI.datagrid("#dlist",{
			 url:$URL,
			 queryParams:{
				 ClassName:"web.DHCBL.MKB.MKBTermProDetail",
				 QueryName:"GetSelPropertyList",
				 property:proid
			 },
			 columns:columns,
			 pagination:false,   //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
			 singleSelect:true,
			 idField:'MKBTPRowId', 
			 rownumbers:true,    //设置为 true，则显示带有行号的列。
			 fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
			 scrollbarSize :0,
			 onLoadSuccess:function(data){
				 $(this).prev().find('div.datagrid-body').prop('scrollTop',0);
			 }
		 }); 
	 }
	 // 表单---属性内容面板---引用知识点
	 var TypeOfTerm =function(proid){
		 var configListOrTree = $.m({ClassName:"web.DHCBL.MKB.MKBTermProDetail",MethodName:"GetProListOrTree",property:proid},false);  //引用术语是树形还是列表型
		 if(configListOrTree=="T"){
			 var datagridHtml ='<table id="dtreeterm" data-options="fit:true,border:false" ></table>';
			 $("#detail").empty();
			 $("#detail").append(datagridHtml);
			 $HUI.tree('#dtreeterm',{
				 bodyCls:'panel-header-gray',
				 url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetDocSourseTreeJson&property="+proid,
				 lines:true,  //树节点之间显示线条
				 autoSizeColumn:true,
				 id:'id',//这里的id其实是所选行的idField列的值
				 cascadeCheck:true,  //是否级联检查。默认true  菜单特殊，不级联操作     
				 animate:false,   //是否树展开折叠的动画效果 
				 onExpand:function(node){
				 },
				 onCollapse:function(node){
				 }
			 });
		 }else{
			 var datagridHtml ='<table id="dlistterm" data-options="fit:true,border:false"></table>';
			 $("#detail").empty();
			 $("#detail").append(datagridHtml);
			 //datagrid列
			 var columns =[[  
					 {field:'MKBTPDRowId',title:'属性内容表id',width:80,hidden:true,resizable:false},
					 {field:'MKBTPDSequence',title:'顺序',width:150,sortable:true,hidden:true,resizable:false,
						 sorter:function (a,b){  
							 if(a.length > b.length) return 1;
							 else if(a.length < b.length) return -1;
							 else if(a > b) return 1;
							 else return -1;
						 }
					 },
					 {field:'MKBTRowId',title:'RowId',width:80,hidden:true,resizable:false},
					 {field:'MKBTDesc',title:'描述',width:150,resizable:false},
					 {field:'MKBTCode',title:'代码',width:150,resizable:false}
				 ]];
				 //列表datagrid
			 var mygrid = $HUI.datagrid("#dlistterm",{
				 bodyCls:'panel-header-gray',
				 url:$URL,
				 queryParams:{
					 ClassName:"web.DHCBL.MKB.MKBTermProDetail",
					 QueryName:"GetSellistTermList",
					 property:proid
				 },
				 columns:columns,
				 pagination: false,   //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
				 idField:'MKBTRowId', 
				 rownumbers:true,    //设置为 true，则显示带有行号的列。
				 fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
				 remoteSort:false,  //定义是否从服务器排序数据。true
				 sortName : 'MKBTPDSequence',
				 sortOrder : 'asc',
				 onLoadSuccess: function(data){
					 $('.mytooltip').tooltip({
						 trackMouse:true,
						 onShow:function(e){
							 $(this).tooltip('tip').css({
								 width:250 ,top:e.pageY+20,left:e.pageX-(250/2)
							 });
						 }
	 
					 });
				  } 
				 //scrollbarSize :0
			 }); 
		 }	
	 }
	 //知识提交功能
	var PREVIEW_FILE_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBKnoManage&pClassMethod=Webservice";
	 var CommitIfo = function() {
		 $('#form-save').form('submit', { 
			 url: "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBKnoManage&pClassMethod=SaveData&pEntityName=web.Entity.MKB.MKBKnoManage",
			 onSubmit: function(param){},
			 success: function (data) { 
				 var data=eval('('+data+')'); 
				 if (data.success == 'true') {
					 var fileName=$('#MKBKnoPathI').val();
					 var pp = fileName.split(".")[fileName.split(".").length-1];
					 if((pp=="doc")||(pp=="docx")||(pp=="xls")||(pp=="xlsx"))
					 {
						 $.ajax({
							 url : PREVIEW_FILE_URL,
							 method : 'POST',
							 data : {
								 path: "D:\\DTHealth\\app\\dthis\\web\\scripts\\bdp\\MKB\\Doc\\Kno\\"+fileName
							 },
							 success: function(){
								 $.messager.popover({msg: '预览文件生成成功！',type:'success',timeout: 1000});
							 }
						 });
					 }
					 $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					 $('#dialog').dialog('close'); // close a dialog
					 
				 }else{
					 var errorMsg ="提交失败！"
					 if (data.errorinfo) {
						 errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
					 }
					 $.messager.alert('操作提示',errorMsg,"error");
				 }
			 }
		 });
		 $('#form-save').form("clear");
		 CreateDataPanel("",""); 
	 }
	 // 知识提交
	 commitkno=function(type,j,termid,proid){
		 CreateDataPanel(type,proid);
		 $("#dialog").show();
		 InitTermBox();
		 var basetype= $.m({ClassName:"web.DHCBL.MKB.MKBTerm",MethodName:"GetBaseTypeByID",ID:base},false);
		 if(basetype=="L"){
			 $("#termbox").combobox("setValue",termid);
		 }else{
			 $("#termbox").combotree("setValue",termid);
		 }
		 var url = $URL+"?ClassName=web.DHCBL.MKB.MKBTermProperty&QueryName=GetList&ResultSetType=array&termdr="+termid;
		 $('#probox').combobox("reload",url);	
		 $("#probox").combobox("setValue",proid);				
		 var autoCode=$.m({ClassName:"web.DHCBL.MKB.MKBKnoManage",MethodName:"GetLastCode"},false);
		 $("#MKBKnoCodeI").val(autoCode);
	 
		 $("#dialog").dialog({
			 resizable:true,
			 title:"知识提交",
			 iconCls:"icon-w-paper",
			 modal:true,
			 buttons:[{
				 text:'提交',
				 handler:function(){
					 //提交表单
					 var fileflag=$('#MKBKnoPathI').val();
					 if(!!fileflag){
							 CommitIfo();
						 }else{
							 $.messager.alert('提示','请先上传文件再提交','info');
							 return
						 }
					 }
				 },{
				 text:'关闭',
				 handler:function(){
					 $("#dialog").dialog("close");
					 $('#form-save').form("clear");
					 $('#probox').combobox('clear');
				 }
			 }]
		 })
	 }
	 
	 ///**************************************知识提交部分结束**************************/
	  /*
	 * 右侧导航代码 - 页面目录结构导航
	 * 滑标动画用的css3过渡动画，不支持的浏览器就没动画效果了
	 */
	 function DirectoryNav($h,config){
		 this.opts = $.extend(true,{
			 scrollThreshold:0.2,    //滚动检测阀值 0.5在浏览器窗口中间部位
			 scrollSpeed:300,        //滚动到指定位置的动画时间
			 scrollTopBorder:300,    //滚动条距离顶部多少的时候显示导航，如果为0，则一直显示
			 easing: 'swing',        //不解释
			 delayDetection:100,     //延时检测，避免滚动的时候检测过于频繁
			 scrollChange:function(){}
		 },config);
		 this.$win = $(window);
		 this.$h = $h;
		 this.$pageNavList = "";
		 this.$pageNavListLis ="";
		 this.$curTag = "";
		 this.$pageNavListLiH = "";
		 this.offArr = [];
		 this.curIndex = 0;
		 this.scrollIng = false;
		 this.init();
	 }
 
	 DirectoryNav.prototype = {
		 init:function(){
			 this.make();
			 this.setArr();
			 this.bindEvent();
		 },
		 make:function(){
			 //生成导航目录结构,这是根据需求自己生成的。
			 $("body").append('<div id="directory-navbefore"><div class="directory-nav" id="directoryNav"><aside class="directory-scroll"><ul></ul></aside><span class="cur-tag"></span><span class="c-top"></span><span class="c-bottom"></span><span class="line"></span></div></div>');
			 var $hs = this.$h,
				 $directoryNav = $("#directoryNav"),
				 temp = [],
				 index1 = 0,
				 index2 = 0;
			 $hs.each(function(index){
				 var $this = $(this),
				 text = $this.text();
				 var texttool=text;
				 (text.length>7)?text=text.substring(0,6):text;
				 if(this.tagName.toLowerCase()=='h2'){
					 index1++;
					 if(index1>18) 
					 {
					   
						 $("#directoryNav").append('<li class="l1"><span class="c-dot"></span><a id="moreend">'+"更多目录"+'</a></li>');
						 return false;
						 
					 }
					 if(index1%2==0) index2 = 0;
					 temp.push('<li class="l1"><span class="c-dot"></span>'+index1+'. <a class="l1-text" title="'+texttool+'">'+text+'</a></li>');
				 }else{
					 index2++;
					 temp.push('<li class="l2">'+index1+'.'+index2+' <a class="l2-text">'+text+'</a></li>');
 
				 }
			 });
			 $directoryNav.find("ul").html(temp.join(""));
			 $("#moreend").click(function(e){
				 $('html,body').animate({scrollTop: $("#more").offset().top}, 500); //滚动效果
				 return false;  //
				//document.getElementById("more").scrollIntoView(true)  //跳转效果
				 })
			 //设置变量
			 this.$pageNavList = $directoryNav;
			 this.$pageNavListLis = this.$pageNavList.find("li");
			 this.$curTag = this.$pageNavList.find(".cur-tag");
			 this.$pageNavListLiH = this.$pageNavListLis.eq(0).height();
 
			 if(!this.opts.scrollTopBorder){
				 this.$pageNavList.show();
			 }
		 },
		 setArr:function(){
			 var This = this;
			 this.$h.each(function(){
				 var $this = $(this),
					 offT = Math.round($(this).offset().top);
				 This.offArr.push(offT);
			 })  
		 },
		 posTag:function(top){
			 this.$curTag.css({top:top+'px'});
		 },
		 ifPos:function(st){
			 var offArr = this.offArr;
			 //console.log(st);
			 var windowHeight = Math.round(this.$win.height() * this.opts.scrollThreshold);
			 for(var i=0;i<offArr.length;i++){
				 if((offArr[i] - windowHeight) < st) {
					 var $curLi = this.$pageNavListLis.eq(i);
					 //console.table($curLi.position())
					  if(!$.isEmptyObject($curLi.position())){
							 tagTop = $curLi.position().top;
					  }
					 $curLi.addClass("cur").siblings("li").removeClass("cur");
					 this.curIndex = i;
					 this.posTag(tagTop+this.$pageNavListLiH*0.5);
					 //this.curIndex = this.$pageNavListLis.filter(".cur").index();
					 this.opts.scrollChange.call(this);
				 }
			 }
		 },
		 bindEvent:function(){
			 var This = this,
				 show = false,
				 timer = 0;
			 this.$win.on("scroll",function(){
				 var $this = $(this);
				 clearTimeout(timer);
				 timer = setTimeout(function(){
					 This.scrollIng = true;
					 if($this.scrollTop()>This.opts.scrollTopBorder){
						 if(!This.$pageNavListLiH) This.$pageNavListLiH = This.$pageNavListLis.eq(0).height();
						 if(!show){
							 This.$pageNavList.fadeIn();
							 show = true;
						 }
						 This.ifPos( $(this).scrollTop() );
					 }else{
						 if(show){
							 This.$pageNavList.fadeOut();
							 show = false;
						 }
					 }
				 },This.opts.delayDetection);
			 });
 
			 this.$pageNavList.on("click","li",function(){
				 var $this = $(this),
					 index = $this.index();
					 //alert($("#h13").offset().top)
					 //alert(This.offArr[index])
				 This.scrollTo(This.offArr[index]);
			 })
		 },
		 scrollTo: function(offset,callback) {
			 var This = this;
			 $('html,body').animate({
				 scrollTop: offset
			 }, this.opts.scrollSpeed, this.opts.easing, function(){
				 This.scrollIng = false;
				 //修正弹两次回调 
				 callback && this.tagName.toLowerCase()=='body' && callback();
			 });
		 }
	 };
	 
	 
	 //文献部分 id='docnum'  更改展示形式20200206
	/*var listHtml=$.m({ClassName:'web.DHCBL.MKB.MKBEncyclopedia',MethodName:'RelationDocHtml',rowid:termdr},false);
	relationdochtml="<div style='padding-left:2px;width:99.8%'><table><tbody>"+listHtml+"</tbody></table></div>";
	$("#relationdoc").append(relationdochtml);*/
	
	 var deschtml = ""
	 deschtml1="<div class='doccontent' style='display:block;'><h1><div style='border-left:#4F9CEE solid 12px;height:28px;width:1%;display:block;margin-left:0;float:left;display:inline-block;'></div><div style='margin:10px 0 0 35px;width:83%;height:28px;background:url(../scripts/bdp/Framework/imgs/paraTitle-line.png);background-position-y:4px;'><div style='padding-right:15px;font-size:16px;font-weight:400;background-color:#FFFFFF;float:left;width:auto;display:inline-block;'>所有文献</div></div></h1></div>";
	 $("#relationdoc").append(deschtml1);
	 $("#relationdoc").append('<div id="doclay" style="width:'+document.body.clientWidth*0.85+'px;height:1000px;padding-left:50px;" border="false"><table id="doc1" data-options="fit:true"  border="true" ></table></div>')
	 $('#doclay').panel();
	 var docdata = $.m({ClassName:'web.DHCBL.MKB.MKBKLMappingDetail',MethodName:'EncyclopediaDocInfo',Exp:termdr,Classify:""},false);
	 var doclength = 0
	 var docdata1 =	[]
	 if (docdata!="")
	 {
		 if(docdata.indexOf("[A]")>-1){
			 var docarr = docdata.split("[A]")
			  doclength = docarr.length
			 for(var i = 0;i<docarr.length;i++){
				 docdata1.push(eval('(' + docarr[i] + ')'))
			 }
			 
		 }else{
			 
			 docdata1.push(eval('(' + docdata + ')'))
			 doclength = 1
		 }
	 }
	 setTimeout(function () {
		if (doclength != 0) {
			$('#docnum').html('文献(' + doclength + ')')
			
			var doccolumns = [[
				{ field: 'DocDesc', title: '文献名称', sortable: true, width: 100 },
				{ field: 'DocPath', title: '路径', hidden: true, width: 100 },
				{ field: 'DocRowId', title: 'RowId', hidden: true, width: 100 },
				{
					field: 'desc1', title: '预览', width: 20, sortable: true,
					formatter: function (value, row, index) {
						var btn = '<a href="#"  id="[A]' + row.DocPath + '" class="preview" style="border:0px;cursor:pointer">预览</a>';
						return btn;
					}
				},
				{
					field: 'desc2', title: '下载', width: 20, sortable: true,
					formatter: function (value, row, index) {
						var btn = '<a href="#" id="[B]' + row.DocPath + '"  class="download load" style="border:0px;cursor:pointer">下载</a>';
						return btn;
					}
				}
			]];
			var docgrid = $HUI.datagrid("#doc1", {
				url: $URL,
				columns: doccolumns,  //列信息
				pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
				//pageSize:PageSizeMain,
				//pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
				singleSelect: true,
				remoteSort: false,
				idField: 'DocRowId',
				bodyCls: 'panel-header-gray',
				rownumbers: true,    //设置为 true，则显示带有行号的列。
				fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
				data: docdata1
			})
			$("#relationdoc .preview").click(function (e) {
				//var path=$(this).parent().text();
				var path = $(this).attr("id").split("[A]")[1]
				previewFile(path);

			})
			$("#relationdoc .download").click(function (e) {
				//var path=$(this).parent().text();
				var path = $(this).attr("id").split("[B]")[1]
				// alert(path)
				DownLoadFile(path);
			})

		} else { 
			$('#docnum').html('');
		}

	},1000)
 
		  
	   //点击下载按钮
	 function DownLoadFile(fileName)
	 {
		 if(fileName)
		 {
			 var isExists=$.m({ClassName:"web.DHCBL.BDP.BDPUploadFile",MethodName:"IsExistsFile",filePath:"scripts\\bdp\\MKB\\Doc\\Doc\\"+fileName},false);
			 var filepath = "../scripts/bdp/MKB/Doc/Doc/"+fileName;
			 if(isExists==1 && fileName!="")
			 {
				 $(".load").attr("href",filepath);
				 $(".load").attr("download",fileName);
				 //判断浏览器是否支持a标签 download属性
				 var isSupportDownload = 'download' in document.createElement('a');
				 if(!isSupportDownload){
					 var fileType = fileName.split(".")[fileName.split(".").length-1];
					 if((fileType!="pdf")&&(fileType!="PDF")){
						 objIframe=document.createElement("IFRAME");
						 document.body.insertBefore(objIframe);
						 objIframe.outerHTML=   "<iframe   name=a1   style='width:0;hieght:0'   src="+$(".load").attr("href")+"></iframe>";
						 pic   =   window.open($(".load").attr("href"),"a1");
						 document.all.a1.removeNode(true)
					 }else{
						 alert("此浏览器使用另存下载");
						 $(".load").attr("target","_blank");
					 }
				 }
			 }else{
				   /*$.messager.show
				   ({ 
					   title: '提示消息', 
					   msg: '该文件不存在！', 
					   showType: 'show', 
					   timeout: 1500, 
					   style: { 
					   right: '', 
					   bottom: ''
					 } 
				 }); */
				 $.messager.popover({msg: '该文件不存在！',type:'alert'});   
			 }       
		 }else{
			 $.messager.alert('错误提示','请先选择一条记录!',"error");
		 }
	 }
	 //点击预览按钮
	 function previewFile(fileName)
	 {
	   
		 if(fileName)
		 {
			 var fileType = fileName.split(".")[(fileName).split(".").length-1];
			 var PDFisExists=$.m({ClassName:"web.DHCBL.BDP.BDPUploadFile",MethodName:"IsExistsFile",filePath:"scripts\\bdp\\MKB\\Doc\\Doc\\"+fileName.replace(fileType,"pdf")},false);
			 if(PDFisExists==1)
			 {
				 var filepath = "../scripts/bdp/MKB/Doc/Doc/"+fileName.replace(fileType,"pdf");
				 var previewWin=$("#win").window({
						 width:$(window).width()*9.7/10,
						 height:$(window).height()*9/10,
						 top:$(document).scrollTop()+20,
						 modal:true,
						 title:fileName
						 
					 });
				  $('#win').html('<object id="PDFViewObject" type="application/pdf" width="100%" height="100%" data='+filepath+' style="display:block"> <div id="PDFNotKnown">你需要先安装pdf阅读器才能正常浏览文件，请点击<a href="http://get.adobe.com/cn/reader/download/?installer=reader_11.0_chinese_simplified_for_windows" target="_blank">这里</a>下载.</div> </object>');
				   previewWin.show();
			 }else{
				   /*$.messager.show({ 
						 title: '提示消息', 
						 msg: '不存在pdf预览文件！', 
						 showType: 'show', 
						 timeout: 1000, 
						 style: { 
						 right: '', 
						 bottom: ''
					 } 
				 }); */
				 $.messager.popover({msg: '不存在pdf预览文件！',type:'alert'});   
			 }       
		 }else{
			 $.messager.alert('错误提示','请先选择一条记录!',"error");
		 }
	 }
	 $("#changeview").tooltip({
		 content:'<span>图谱百科切换</span>',
		 position: 'left', //top , right, bottom, left
		 onShow: function(){    
			 $(this).tooltip('tip').css({
				 backgroundColor: '#666', 
				 borderColor: '#666'
			 });   
		 }
	 })
	 
 
 })