/**   
 * @Title: 医为百科 
 * @Description:查看知识
 * @author: 程和贵
 * @Created:  2018-05-18 
 * @Edit:  2020-09-27 石萧伟   
 */

 $(function () {
	$("#div-img").hide();
	var jumpIndex = 0;
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
	function CDSSMakeServerCall (DataInfo){
		var returnInfo ="";
		var str = DataInfo.replace(/\"/g, '""')
		returnInfo = tkMakeServerCall("web.CDSS.Public.MethodForWebservice","CallMethod",str)
		return returnInfo
	}
	var MInterface = tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","CDSSDataServerIP")
	MInterface = MInterface+"/web";
	var termdrDesc = CDSSMakeServerCall("web.CDSS.CMKB.Term[A]GetDesc[A]"+termdr);
	String.addSpace = function (str) {
			 return str.split("").join(" ");
	};
	termdrDesc = String.addSpace(termdrDesc);

	var textData = CDSSMakeServerCall("web.CDSS.CMKB.Encyclopedia[A]GetTermInfo[A]" + termdr);
	if (textData) { 
		var  textData= eval('('+textData+')');  
		//console.log(textData)
		//基本信息
		$("#head_h1").html(termdrDesc+"<p style='text-align:left;margin-left:17px;font-weight:bold'></p>"+"<p style='text-indent:2em;text-align: left;margin-left:17px; width:"+document.body.clientWidth*0.9+"px' id='head_h11'></p><table id='baseinfotable' style='margin:15px 17px'><tbody><tr><td class='tdname'>全称:</td><td class='tdvalue'>"+textData.MKBTDesc+"</td><td class='tdname'>别名:</td><td class='tdvalue'>"+textData.MKBTOther.split("||")[0]+"</td><td class='tdname'>所属知识:</td><td class='tdvalue'>"+textData.MKBTBaseDR+"</td></tr></tbody></table>");
		//获取是否开启UpToDate配置
		var ShowUpToDate = CDSSMakeServerCall("web.DHCBL.MKB.MKBConfig[A]GetConfigValue[A]ShowUpToDate")

		if(ShowUpToDate=="Y"){
			   $("#head_h1").after("<div id='linktab' class='changetab' style='height:40px;background-color:#f4f6f5;width:95%;border-bottom:#40a2de solid 1px;margin-left:50px'><a class='changetabs select'><i><span>知识概况<span></i></a><a class='changetabs'><i><span id='docnum'></span></i></a><a class='changetabs'><i><span>UpToDate临床顾问<span></i></a></div>")
		}else{
				$("#head_h1").after("<div id='linktab' class='changetab' style='height:40px;background-color:#f4f6f5;width:95%;border-bottom:#40a2de solid 1px;margin-left:50px'><a class='changetabs select'><i><span>知识概况<span></i></a><a class='changetabs'><i><span id='docnum'></span></i></a></div>")		   
		}
		/*$("#changeview").click(function(e){
			var _height=document.documentElement.clientHeight || document.body.clientHeight;
			var _width = document.documentElement.clientWidth || document.body.clientWidth;
			$("#iframeview").css("height",_height-20);
			$("#iframeview").css("width",_width);
			if( $("#iframeview").css("display")=="none"){
				 $("#head_h").css("display","none");
				 $("#iframeview").css("display","block");
				 $("#directory-navbefore").css('display','none');
				 $("#iframeview").attr("src","dhc.bdp.mkb.mkbdiagbrowser.csp?termdr="+termdr+"&base="+base)
				 $("#changeview").css("padding-right","8px");
 
				 //$("body").css("padding","0");
			}else{
				 $("#iframeview").css("display","none");
				 $("#head_h").css("display","block");
				 $("#changeview").css("padding-right","0");
				 $("#directory-navbefore").css('display','block');
				 //$("body").css("padding","0 10px 0 10px")
			}
		})*/
		$(".changetabs").click(function(e){
			if(!$(this).hasClass("select")){
				$(this).addClass('select');
				$(this).siblings().removeClass('select');
				if($(".select").text()!="知识概况"&&$(".select").text()!="UpToDate临床顾问"){
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
					var UpToDateURL = CDSSMakeServerCall("web.DHCBL.MKB.MKBConfig[A]GetConfigValue[A]UpToDateURL")
					$('#upiframe').attr('src',UpToDateURL+'?search='+termDesc)
				}
			}
		})        

	}
	//获取浏览器页面可见高度和宽度
	var _PageHeight = document.documentElement.clientHeight,
	    _PageWidth = document.documentElement.clientWidth;
	//计算loading框距离顶部和左部的距离（loading框的宽度为215px，高度为61px）
	var _LoadingTop = _PageHeight > 61 ? (_PageHeight - 61) / 2 : 0,
	    _LoadingLeft = _PageWidth > 215 ? (_PageWidth - 215) / 2 : 0;
	//在页面未加载完毕之前显示的loading Html自定义内容
	var _LoadingHtml = '<div id="loadingDiv" style="position:absolute;left:0;width:100%;height:' + _PageHeight + 'px;top:0;background:#fff;opacity:1;filter:alpha(opacity=80);z-index:10000;"><div style="position: absolute; cursor1: wait; left: ' + _LoadingLeft + 'px; top:' + _LoadingTop + 'px; width: auto; height: 57px; line-height: 57px; padding-left: 50px; padding-right: 50px; background:url(../scripts/bdp/Framework/icons/mkb/page_loading.gif) no-repeat scroll 5px 10px; "></div></div>';
	//呈现loading效果
	$('body').append(_LoadingHtml);
	 //展示医为百科首页的所有属性及内容
	setTimeout(function () {  //加延迟解决首页属性标题栏出不来的问题
		// $.ajax({
        //     url:MInterface+"/csp/dhc.bdp.cdss.queryforcdss.csp?CacheNoRedirect=1&CacheUserName=dhsyslogin&CachePassword=1q2w3e4r%T6y7u8i9o0p&pClassName=web.CDSS.CMKB.Encyclopedia&pClassQuery=GetList&termdr="+encodeURIComponent(termdr),
        //     type: "GET",
        //     //dataType: "json",
		// 	success: function (data) {   
				var data = CDSSMakeServerCall("web.CDSS.Public.MethodForEncyclopediaV2[A]GetList[A]"+termdr);
				var jsonData = eval('(' + data + ')');
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
						"<div style='border-left:#4F9CEE solid 6px;height:18px;margin-top:6px;border-radius: 5px;width: 0px;display:block;margin-left:0;float:left;display:inline-block;'>" +
						"</div>" +
						"<div style='margin:10px 0 0 15px;width:83%;height:28px;'>" +
						"<div style='padding-right:15px;font-size:16px;font-weight:400;background-color:#FFFFFF;float:left;width:auto;display:inline-block;'>" + MKBTPDesc1 + "" +
						"</div>" +
						"</div>" +
						//"<div style='width:20px;margin-right:14%;margin-top:-22px;height:20px;background-color:#FFFFFF'><a href='javascript:void(0)' class='commit hisui-tooltip'><img src='../scripts/bdp/framework/icons/mkb/commitkno.png' onclick=commitkno('" + type + "'," + j + "," + termdr + "," + MKBTPRowId + ")></img></a>" +
						//"</div>" +
						"</h2>" +
						"<div style='width:78.8%;border-top:#ccc solid 1px;margin-left:50px'>" +
						"</div>" +
						"<div id='div" + j + "' style='height:auto;margin-left:50px;width:78.8%;border:1px solid #C0C0C0;border-radius:4px'>" +
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
					//var extendInfo = $.m({ ClassName: 'web.CDSS.CMKB.TermProDetail', MethodName: 'getExtendInfo', property: propertyid }, false);
					var extendInfo = CDSSMakeServerCall("web.CDSS.CMKB.TermProDetail[A]getExtendInfo[A]"+propertyid );

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
						//var QUERY_ACTION_URL = MInterface+"/csp/dhc.bdp.ext.datatrans.csp?pClassName=web.CDSS.CMKB.TermProDetail&pClassMethod=GetMyList";
						//列表datagrid
						var mygrid = $HUI.datagrid("#llist" + j, {
							//url: QUERY_ACTION_URL + "&property=" + propertyid + "&rows=9999999&page=1",
							data:[],
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
						var dataInfo = CDSSMakeServerCall("web.CDSS.Public.MethodForEncyclopediaV2[A]GetMyList[A]" + propertyid);
						if (dataInfo) { 
							$("#llist" + j).datagrid('loadData', eval('(' + dataInfo + ')'));
						}

					}
					else if (type == "T") {
						iframhtml = "<table border='false' id='treegrid" + j + "'></table>"
						$("#div" + j).append(iframhtml);
						//var QUERY_ACTION_URL = MInterface+"/csp/dhc.bdp.ext.datatrans.csp?pClassName=web.CDSS.CMKB.Encyclopedia&pClassMethod=GetJsonList";
						//列表datagrid
						var mygrid = $HUI.treegrid("#treegrid" + j, {
							//url: QUERY_ACTION_URL + "&property=" + propertyid,
							columns: columns,
							idField: 'id',
							data:[],
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
						var dataInfo = CDSSMakeServerCall("web.CDSS.Public.MethodForEncyclopediaV2[A]GetJsonList[A][A]" + propertyid);
						if (dataInfo) { 
							$("#treegrid" + j).treegrid('loadData', eval('('+dataInfo+')'));
						}
					}
					else if ((type == "TA") || (type == "TX") || (type == "C") || (type == "CB") || (type == "R") || (type == "F") || (type == "SD") || (type == "ETX")) {
						//var tmpdesc = $.m({ ClassName: 'web.CDSS.CMKB.Encyclopedia', MethodName: 'GetDetailDesc', id: propertyid, type: type }, false);
						var tmpdesc = CDSSMakeServerCall("web.CDSS.CMKB.Encyclopedia[A]GetDetailDesc[A]"+propertyid+"[A]"+type );
						if(tmpdesc.indexOf("text-indent: 2em;")>-1){
							tmpdesc = tmpdesc.replace(/<p style=\\"text-indent: 2em;\\">/g, '<p style="text-indent: 2em;margin-top:10px">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp')
							//console.log(tmpdesc)
						}
						// if(MKBTPDesc=="疾病概述"){
						// 	$('#head_h11').html(tmpdesc.replace("margin-top:10px;",""))
						// }
						$("#div" + j).append(tmpdesc);
						if(type =="ETX"){
							$("#div" + j + " table").css({
								'border-collapse':'collapse',
								'border-spacing':'0'
							})
							$("#div" + j + " table td").css({
								'border-right':'1px solid #888',
								'border-bottom':'1px solid #888',
								'padding':'5px 15px'
							})
							
						}
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
										//var showvalue = $.m({ ClassName: "web.CDSS.CMKB.TermProDetail", MethodName: "GetDesc", id: v }, false);
										var showvalue = CDSSMakeServerCall("web.CDSS.CMKB.TermProDetail[A]GetDesc[A]"+v );
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
							// url: $URL,
							// queryParams: {
							// 	ClassName: "web.CDSS.CMKB.TermProDetail",
							// 	QueryName: "GetSelPropertyList",
							// 	property: propertyid
							// },
							data:[],
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
						var plistdata = CDSSMakeServerCall("web.CDSS.Public.MethodForEncyclopediaV2[A]GetSelPropertyList[A]"+propertyid);
						var plistdata = eval('(' + plistdata + ')');
						$("#plist" + j).datagrid('loadData',plistdata)
						/*$.ajax({
							url: MInterface + "/csp/dhc.bdp.cdss.queryforcdss.csp?CacheNoRedirect=1&CacheUserName=dhsyslogin&CachePassword=1q2w3e4r%T6y7u8i9o0p&pClassName=web.CDSS.CMKB.TermProDetail&pClassQuery=GetSelPropertyList&property="+ propertyid,
							type: "GET",
							//dataType: "json",
							success: function (data) {
								var dd = eval('(' + data + ')');
								$("#plist" + j).datagrid('loadData',data)
							},
							error: function () {
								console.log("忽略预警请求数据失败")
							}
						});*/
					}
					else if (type == "S") {
						//var configListOrTree = $.m({ ClassName: "web.CDSS.CMKB.TermProDetail", MethodName: "GetProListOrTree", property: propertyid }, false);  //引用术语是树形还是列表型
						var configListOrTree = CDSSMakeServerCall("web.CDSS.CMKB.TermProDetail[A]GetProListOrTree[A]"+propertyid );
						if (configListOrTree == "T") {
							iframhtml = '<table id="treeterm' + j + '" data-options="fit:false,border:false"></table>';
							$("#div" + j).append(iframhtml);
							$HUI.tree('#treeterm' + j, {
								//url: MInterface+"/csp/dhc.bdp.ext.datatrans.csp?pClassName=web.CDSS.CMKB.TermProDetail&pClassMethod=GetDocSourseTreeJson&property=" + propertyid,
								data:[],
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
							var dataInfo = CDSSMakeServerCall("web.CDSS.Public.MethodForEncyclopediaV2[A]]GetDocSourseTreeJson[A]"+ propertyid);
							if (dataInfo) { 
								$('#treeterm' + j).tree('loadData', eval('(' + dataInfo + ')'));
							}
	
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
								// url: $URL,
								// queryParams: {
								// 	ClassName: "web.CDSS.CMKB.TermProDetail",
								// 	QueryName: "GetSellistTermList",
								// 	property: propertyid
								// },
								data:[],
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
							var listdata = CDSSMakeServerCall("web.CDSS.Public.MethodForEncyclopediaV2[A]GetSellistTermList[A]"+propertyid);
							var listdata = eval('(' + listdata + ')');
							$("#listterm" + j).datagrid('loadData',listdata)
	
							/*$.ajax({
								url: MInterface + "/csp/dhc.bdp.cdss.queryforcdss.csp?CacheNoRedirect=1&CacheUserName=dhsyslogin&CachePassword=1q2w3e4r%T6y7u8i9o0p&pClassName=web.CDSS.CMKB.TermProDetail&pClassQuery=GetSellistTermList&property="+ propertyid,
								type: "GET",
								//dataType: "json",
								success: function (data) {
									var dd = eval('(' + data + ')');
									$("#listterm" + j).datagrid('loadData',data)
								},
								error: function () {
									console.log("忽略预警请求数据失败")
								}
							});*/
						}
					}
					else if (type == "SS") {//---引用起始节点---石萧伟
						iframhtml = '<table id="streeterm' + j + '" data-options="fit:false,border:false"></table>';
						$("#div" + j).append(iframhtml);
						$HUI.tree('#streeterm' + j, {
							//url: MInterface+"/csp/dhc.bdp.ext.datatrans.csp?pClassName=web.CDSS.CMKB.TermProDetail&pClassMethod=GetSourseSingleTermJson&property=" + propertyid,
							data:[],
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
						var dataInfo = CDSSMakeServerCall("web.CDSS.Public.MethodForEncyclopediaV2[A]GetSourseSingleTermJson[A]" + propertyid);
						if (dataInfo) { 
							$('#streeterm' + j).tree('loadData', eval('(' + dataInfo + ')'));
						}
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
					jumpIndex = id.split('h')[1];
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
		// 	},
        //     error:function(){
        //         console.log("请求数据失败")
        //     }
        // });
		var loadingMask = document.getElementById('loadingDiv');
		loadingMask.parentNode.removeChild(loadingMask);

	 },100); 
   
	 ///**************************************知识提交部分开始**************************/

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
		init: function () {
			this.make();
			this.setArr();
			this.bindEvent();
		},
		make: function () {
			//生成导航目录结构,这是根据需求自己生成的。
			$("body").append('<div id="directory-navbefore"><div class="directory-nav" id="directoryNav"><aside class="directory-scroll"><ul></ul></aside><span class="cur-tag"></span><span class="c-top"></span><span class="c-bottom"></span><span class="line"></span></div></div>');
			var $hs = this.$h,
				$directoryNav = $("#directoryNav"),
				temp = [],
				index1 = 0,
				index2 = 0;
			$hs.each(function (index) {
				var $this = $(this),
					text = $this.text();
				var texttool = text;
				(text.length > 7) ? text = text.substring(0, 6) : text;
				if (this.tagName.toLowerCase() == 'h2') {
					index1++;
					if (index1 > 18) {

						$("#directoryNav").append('<li class="l1"><span class="c-dot"></span><a id="moreend">' + "更多目录" + '</a></li>');
						return false;

					}
					if (index1 % 2 == 0) index2 = 0;
					temp.push('<li class="l1" id=li'+index1+'><span class="c-dot"></span>' + index1 + '. <a class="l1-text" title="' + texttool + '">' + text + '</a></li>');
				} else {
					index2++;
					temp.push('<li class="l2">' + index1 + '.' + index2 + ' <a class="l2-text">' + text + '</a></li>');

				}
			});
			$directoryNav.find("ul").html(temp.join(""));
			$("#moreend").click(function (e) {
				$('html,body').animate({ scrollTop: $("#more").offset().top }, 500); //滚动效果
				return false;  //
				//document.getElementById("more").scrollIntoView(true)  //跳转效果
			})
			var _that = this
			$("#directoryNav").find('li').each(function(){
				$(this).click(function(){
					_that.clickscroll=$(this).attr('id').split('li')[1]
					setTimeout(function(){
						var $curLi = _that.$pageNavListLis.eq(_that.clickscroll-1);
						//console.table($curLi.position())
						if (!$.isEmptyObject($curLi.position())) {
							tagTop = $curLi.position().top;
						}
						_that.posTag(tagTop + _that.$pageNavListLiH * 0.5);
					},500)
				})

			})
			//设置变量
			
			this.$pageNavList = $directoryNav;
			this.$pageNavListLis = this.$pageNavList.find("li");
			this.$curTag = this.$pageNavList.find(".cur-tag");
			this.$pageNavListLiH = this.$pageNavListLis.eq(0).height();

			if (!this.opts.scrollTopBorder) {
				this.$pageNavList.show();
			}
		},
		setArr: function () {
			var This = this;
			this.$h.each(function () {
				var $this = $(this),
					offT = Math.round($(this).offset().top);
				This.offArr.push(offT);
			})
		},
		posTag: function (top) {
			this.$curTag.css({ top: top + 'px' });
		},
		ifPos: function (st) {
			var offArr = this.offArr;
			//console.log(st);
			var windowHeight = Math.round(this.$win.height() * this.opts.scrollThreshold);
			for (var i = 0; i < offArr.length; i++) {
				if ((offArr[i] - windowHeight) < st) {
					var $curLi = this.$pageNavListLis.eq(i);
					//console.table($curLi.position())
					if (!$.isEmptyObject($curLi.position())) {
						tagTop = $curLi.position().top;
					}
					$curLi.addClass("cur").siblings("li").removeClass("cur");
					this.curIndex = i;
					this.posTag(tagTop + this.$pageNavListLiH * 0.5);
					//this.curIndex = this.$pageNavListLis.filter(".cur").index();
					this.opts.scrollChange.call(this);
				}
			}
		},
		bindEvent: function () {
			var This = this,
				show = false,
				timer = 0;
			this.$win.on("scroll", function () {
				var $this = $(this);
				clearTimeout(timer);
				timer = setTimeout(function () {
					This.scrollIng = true;
					if ($this.scrollTop() > This.opts.scrollTopBorder) {
						if (!This.$pageNavListLiH) This.$pageNavListLiH = This.$pageNavListLis.eq(0).height();
						if (!show) {
							This.$pageNavList.fadeIn();
							show = true;
						}
						This.ifPos($(this).scrollTop());
					} else {
						if (show) {
							This.$pageNavList.fadeOut();
							show = false;
						}
					}
				}, This.opts.delayDetection);
			});

			this.$pageNavList.on("click", "li", function () {
				var $this = $(this),
					index = $this.index();
				//alert($("#h13").offset().top)
				//alert(This.offArr[index])
				This.scrollTo(This.offArr[index]);
			})
		},
		scrollTo: function (offset, callback) {
			var This = this;
			$('html,body').animate({
				scrollTop: offset
			}, this.opts.scrollSpeed, this.opts.easing, function () {
				This.scrollIng = false;
				//修正弹两次回调 
				callback && this.tagName.toLowerCase() == 'body' && callback();
			});
		}
	};

	 
	
	 var deschtml = ""
	 deschtml1="<div class='doccontent' style='display:block;'><h1><div style='border-left:#4F9CEE solid 6px;height:18px;margin-top:6px;border-radius: 5px;width: 0px;display:block;margin-left:0;float:left;display:inline-block;'></div><div style='margin:10px 0 0 15px;width:83%;height:28px;background:url(../scripts/bdp/framework/imgs/paraTitle-line.png);background-position-y:4px;'><div style='padding-right:15px;font-size:16px;font-weight:400;background-color:#FFFFFF;float:left;width:auto;display:inline-block;'>所有文献</div></div></h1></div>";
	 $("#relationdoc").append(deschtml1);
	 $("#relationdoc").append('<div id="doclay" style="width:'+document.body.clientWidth*0.85+'px;height:10000px;padding-left:50px;" border="false"><table id="doc1" data-options="fit:true"  border="true" ></table></div>')
	 $('#doclay').panel();
	 /*var docdata = CDSSMakeServerCall("web.DHCBL.MKB.MKBKLMappingDetail[A]EncyclopediaDocInfo[A]"+termdr);

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
						var btn = '<a href="javascript:void(0);"  id="[A]' + row.DocPath + '" class="preview" style="border:0px;cursor:pointer">预览</a>';
						return btn;
					}
				},
				{
					field: 'desc2', title: '下载', width: 20, sortable: true,
					formatter: function (value, row, index) {
						var btn = '<a href="javascript:void(0);" id="[B]' + row.DocPath + '"  class="download load" style="border:0px;cursor:pointer">下载</a>';
						return btn;
					}
				}
			]];
			var docgrid = $HUI.datagrid("#doc1", {
				//url: $URL,
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
				var sJSON = [{
					UserID:session['LOGON.USERID'],
					UserName:session['LOGON.USERNAME'],
					CTLocID:session['LOGON.CTLOCID'],
					CTLocDesc:session['LOGON.CTLOCDESC'],
					VisitType:'',
					ClickTime:getNowFormatTime(),
					OperType:'查看',
					ClickModule:'诊断决策',//模块
					ClickProType:'医为文献',//确诊，疑似疾病、治疗方案
					ClickProName:'',
					ClickText:path,
					ClickType:''
				}]
				var statistics = CDSSMakeServerCall("web.CDSS.Statistics.UserClickStatic[A]SaveUserClickStaticData[A]"+JSON.stringify(sJSON));

				previewFile(path);

			})
			$("#relationdoc .download").click(function (e) {
				//var path=$(this).parent().text();
				var path = $(this).attr("id").split("[B]")[1]
				var sJSON = [{
					UserID:session['LOGON.USERID'],
					UserName:session['LOGON.USERNAME'],
					CTLocID:session['LOGON.CTLOCID'],
					CTLocDesc:session['LOGON.CTLOCDESC'],
					VisitType:'',
					ClickTime:getNowFormatTime(),
					OperType:'下载',
					ClickModule:'诊断决策',//模块
					ClickProType:'医为文献',//确诊，疑似疾病、治疗方案
					ClickProName:'',
					ClickText:path,
					ClickType:''
				}]
				var statistics = CDSSMakeServerCall("web.CDSS.Statistics.UserClickStatic[A]SaveUserClickStaticData[A]"+JSON.stringify(sJSON));

				// alert(path)
				DownLoadFile(path);
			})

		} else { 
			$('#docnum').html('');
		}

	},1000)*/
 

     setTimeout(function () {
        var docdata = CDSSMakeServerCall("web.CDSS.Public.MethodForEncyclopediaV2[A]GetDocList[A]"+termdr);
        docdata = eval('(' + docdata + ')');

         doclength = docdata.rows.length
		if (doclength != 0) {
			$('#docnum').html('文献(' + doclength + ')')
			
			var doccolumns = [[
				{ field: 'DocuDesc', title: '文献名称', sortable: true, width: 100 },
				{ field: 'DocuPath', title: '路径', hidden: true, width: 100 },
				{ field: 'RowId', title: 'RowId', hidden: true, width: 100 },
				{
					field: 'desc1', title: '预览', width: 20, sortable: true,
					formatter: function (value, row, index) {
						var btn = '<a href="javascript:void(0);"  id="[A]' + row.DocuPath + '" class="preview" style="border:0px;cursor:pointer">预览</a>';
						return btn;
					}
				},
				{
					field: 'desc2', title: '下载', width: 20, sortable: true,
					formatter: function (value, row, index) {
						var btn = '<a href="javascript:void(0);" id="[B]' + row.DocuPath + '"  class="download load" style="border:0px;cursor:pointer">下载</a>';
						return btn;
					}
				}
			]];
			var docgrid = $HUI.datagrid("#doc1", {
				//url: $URL,
				columns: doccolumns,  //列信息
				pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
				//pageSize:PageSizeMain,
				//pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
				singleSelect: true,
				remoteSort: false,
				idField: 'RowId',
				bodyCls: 'panel-header-gray',
				rownumbers: true,    //设置为 true，则显示带有行号的列。
				fitColumns: true //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
				//data: docdata.rows
            })
            $('#doc1').datagrid('loadData',docdata.rows)
			$("#relationdoc .preview").click(function (e) {
				//var path=$(this).parent().text();
				var path = $(this).attr("id").split("[A]")[1]
				var sJSON = [{
					UserID:session['LOGON.USERID'],
					UserName:session['LOGON.USERNAME'],
					CTLocID:session['LOGON.CTLOCID'],
					CTLocDesc:session['LOGON.CTLOCDESC'],
					VisitType:'',
					ClickTime:getNowFormatTime(),
					OperType:'查看',
					ClickModule:'诊断决策',//模块
					ClickProType:'医为文献',//确诊，疑似疾病、治疗方案
					ClickProName:'',
					ClickText:path,
					ClickType:''
				}]
				var statistics = CDSSMakeServerCall("web.CDSS.Statistics.UserClickStatic[A]SaveUserClickStaticData[A]"+JSON.stringify(sJSON));

				previewFile(path);

			})
			$("#relationdoc .download").click(function (e) {
				//var path=$(this).parent().text();
				var path = $(this).attr("id").split("[B]")[1]
				var sJSON = [{
					UserID:session['LOGON.USERID'],
					UserName:session['LOGON.USERNAME'],
					CTLocID:session['LOGON.CTLOCID'],
					CTLocDesc:session['LOGON.CTLOCDESC'],
					VisitType:'',
					ClickTime:getNowFormatTime(),
					OperType:'下载',
					ClickModule:'诊断决策',//模块
					ClickProType:'医为文献',//确诊，疑似疾病、治疗方案
					ClickProName:'',
					ClickText:path,
					ClickType:''
				}]
				var statistics = CDSSMakeServerCall("web.CDSS.Statistics.UserClickStatic[A]SaveUserClickStaticData[A]"+JSON.stringify(sJSON));

				// alert(path)
				DownLoadFile(path);
			})

		} else { 
			$('#docnum').html('');
		}

	},1000)
 
		  	//获取当前日期，格式YYYY-MM-DD
	function getNowFormatDay(nowDate) {
		var char = "-";
		if(nowDate == null){
			nowDate = new Date();
		}
		var day = nowDate.getDate();
		var month = nowDate.getMonth() + 1;//注意月份需要+1
		var year = nowDate.getFullYear();
		//补全0，并拼接
		return year + char + completeDate(month) + char +completeDate(day);
	}
	//补全0
	function completeDate(value) {
		return value < 10 ? "0"+value:value;
	}
	//获取当前时间，格式YYYY-MM-DD HH:mm:ss
	function getNowFormatTime() {
		var nowDate = new Date();
		var colon = ":";
		var h = nowDate.getHours();
		var m = nowDate.getMinutes();
		var s = nowDate.getSeconds();
		//补全0，并拼接
		return getNowFormatDay(nowDate) + " " + completeDate(h) + colon + completeDate(m) + colon + completeDate(s);
	}

	//点击下载按钮
	 function DownLoadFile(fileName)
	 {
		 if(fileName)
		 {
			 var isExists = CDSSMakeServerCall("web.CDSS.CMKB.UploadFile[A]IsExistsFile[A]scripts/bdp/CDSS/Doc/"+fileName);

			 var filepath = MInterface+"/scripts/bdp/CDSS/Doc/" + fileName;
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
			 //var PDFisExists = $.m({ ClassName: "web.DHCBL.BDP.BDPUploadFile", MethodName: "IsExistsFile", filePath: "scripts\\bdp\\MKB\\Doc\\Doc\\" + fileName.replace(fileType, "pdf") }, false);
			 var PDFisExists = CDSSMakeServerCall("web.CDSS.CMKB.UploadFile[A]IsExistsFile[A]scripts/bdp/CDSS/Doc/" + fileName.replace(fileType, "pdf") );
			 if(PDFisExists==1)
			 {
				 var filepath =MInterface+"/scripts/bdp/CDSS/Doc/"+fileName.replace(fileType,"pdf");
				 /*var previewWin=$("#win").window({
						 width:$(window).width()*9.7/10,
						 height:$(window).height()*9/10,
						 top:$(document).scrollTop()+20,
						 modal:true,
						 title:fileName
						 
					 });
				  $('#win').html('<object id="PDFViewObject" type="application/pdf" width="100%" height="100%" data='+filepath+' style="display:block"> <div id="PDFNotKnown"></div> </object>');
				   previewWin.show();*/
				   window.open(filepath)

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

	 
 
 })