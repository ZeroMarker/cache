/*
created by scl
��ӡ����js
 */
var print = opdoc.lib.ns("opdoc.print");
print.common = (function() {
	var ActiveXArr = new Array("MSXML2.DOMDocument.5.0",
			"MSXML2.DOMDocument.4.0", "MSXML2.DOMDocument.3.0",
			"MSXML2.DOMDocument", "Microsoft.XMLDOM", "MSXML.DOMDocument");
	var eleIdMap = {};

	var previewDefaultOptions = {
		"action" : "ReadOne",
		"templateId" : "",
		"ajax" : null,
		"$targetPanel" : null,
		"TxtDataCallBack" : null,
		"TxtDataItemCallBack" : null,
		"PLDataCallBack" : null,
		"PLDataItemCallBack" : null,
		"ListDataCallBack" : null,
		"ListDataItemCallBack" : null,
		"PICDataCallBack" : null
	};
	function opPrintCallBack(options,callBack){
		options = $.extend({}, previewDefaultOptions, options);
		var ajaxData={};
		if (!options["templateId"]) {
			console.log("templateId can't be null!");
			return null;
		}
		if (!options["ReadyJson"]) {
			console.log("ReadyJson can't be null!");
			return null;
		}
		var respData=options["ReadyJson"];
		var reportId = options["templateId"];
		var xmlName=options["PrintTemp"];
		if (!xmlName) {
			var xmlName=$.cm({
				ClassName:"web.DHCDocPrescript",
				MethodName:"GetXMLTemplateName",
				dataType:"text",
				XMLTemplateID:reportId
			},false);
			callBack(options, respData, xmlName); //resolveTemplate
		}else{
			callBack(options, respData, xmlName); //resolveTemplate
		}
	}
	function opCallBack(options,callBack) {
		options = $.extend({}, previewDefaultOptions, options);
		var ajaxData={};
		if (!options["templateId"]) {
			console.log("templateId can't be null!");
			return null;
		}
		if (!options["ReadyJson"]) {
			console.log("ReadyJson can't be null!");
			return null;
		}
		var reportId = options["templateId"];// cspRunServerMethod(options["templateClassMethod"],options["templateName"]);
		ajaxData["reportID"] = reportId;
		var action = options["action"];
		action = action ? action : "ReadOne";
		ajaxData["ExcuteAction"] = action;
		if(typeof websys_getMWToken=='function') ajaxData["MWToken"]=websys_getMWToken();
		requestTemp(options["ReadyJson"]);
		function requestTemp(respData){
			$.ajax("../../web/web.DHCPrintDesigner.cls",{
					type : 'POST',
					async: false,
					data : ajaxData,
					dataType : options["dataType"]||'xml',
					success : function(xml) {
						callBack(options, respData, xml); //resolveTemplate
					},
					error : function(XMLHttpRequest, textStatus, errorThrown) {
						console.log(XMLHttpRequest);
					}
				});
		}
	}
	function DHCP_TextEncoder(transtr){
		if (transtr.length==0){
			return "";
		}
		var dst=transtr;
		try{
			dst = DHCP_replaceAll(dst, '\\"', '\"');
			dst = DHCP_replaceAll(dst, "\\r\\n", "\r\t");
			dst = DHCP_replaceAll(dst, "\\r", "\r");
			dst = DHCP_replaceAll(dst, "\\n", "\n");
			dst = DHCP_replaceAll(dst, "\\t", "\t");
		}catch(e){
			alert(e.message);
			return "";
		}
		return dst;
	}
	function preview(options) {
		opCallBack(options,resolveTemplate);
	}
	function print(options){
		options["dataType"]="text";
		//opCallBack(options,printResolve);
		opPrintCallBack(options,printResolve);
	}
	function resolveTemplate(options, jsonData, xml) { 
		if(!xml.childNodes || xml.childNodes.length==0) return null;
		var xmlDom=xml.childNodes[0];
		var targetPanel = options["$targetPanel"];
		if (true) {
			var pageNode =xmlDom.childNodes[0];
			if (pageNode.nodeType =="3"){
				pageNode=xmlDom.childNodes[1];
			}
			targetPanel.height(790);
			//targetPanel.height(( (pageNode.getAttribute("height"))));//790);convertPtToPx  parseFloat
			//targetPanel.width(( (pageNode.getAttribute("width"))));  //525);
			var count = pageNode.childNodes.length;
			var itemNode = null;
			for (var i = 0; i < count; ++i) {
				itemNode = pageNode.childNodes[i];
				var childCount = itemNode.childNodes.length;
				switch (itemNode.nodeName.toUpperCase()) {
				case "TXTDATA":
					if (childCount > 0) {
						if (options["TxtDataCallBack"]
								&& $.type(options["TxtDataCallBack"]) === "function") {
							options["TxtDataCallBack"](jsonData, itemNode);
						} else if (targetPanel
								&& (targetPanel instanceof jQuery)) {
							formatTxtData(targetPanel, jsonData, itemNode,
									options["TxtDataItemCallBack"]);
						}
					}
					break;
				case "PLDATA":
					if (options["PLDataCallBack"]
							&& $.type(options["PLDataCallBack"]) === "function") {
						options["PLDataCallBack"](jsonData, itemNode);
					} else if (targetPanel && (targetPanel instanceof jQuery)) {
						formatPLData(targetPanel, jsonData, itemNode,
								options["PLDataItemCallBack"]);
					}
					break;
				case "LISTDATA":
					if (childCount > 0) {
						if (options["ListDataCallBack"]
								&& $.type(options["ListDataCallBack"]) === "function") {
							options["ListDataCallBack"](jsonData, itemNode);
						} else if (targetPanel
								&& (targetPanel instanceof jQuery)) {
							formatListData(targetPanel, jsonData, itemNode,
									options["ListDataItemCallBack"]);
						}
					}
					break;
				case "PICDATA":
					if (childCount > 0) {
						xmlToImg(itemNode);
						if (options["PICDataCallBack"]
								&& $.type(options["PICDataCallBack"]) === "function") {
							options["PICDataCallBack"](jsonData, itemNode);
						} else if (targetPanel
								&& (targetPanel instanceof jQuery)) {
							xmlToImg(itemNode, jsonData, targetPanel);
						}
					}
					break;
				case "TESTPARAMDATA":
					break;
				default:
					break;
				}
			}
		}
	}
	function printResolve(options, jsonData, xmlName){
		var joinedData=joinJson(jsonData);
		DHCP_GetXMLConfig("InvPrintEncrypt",xmlName);
		//var docobj=createXMLDOM();
		//docobj.async = false; 
		//var rtn=docobj.loadXML(xml);
		//if(rtn){
			//var root=docobj.lastChild;
			var onePageNums=options["printPageNums"];
			var txtPara=DHCP_TextEncoder(joinedData["proValue"]);
			var list=DHCP_TextEncoder(joinedData["arrValue"]);
			if (onePageNums>1){
				var listLen=list.split(String.fromCharCode(2)).length;
			    var Len=Math.ceil(listLen/onePageNums); //����ȡ��
				for (var i=1;i<=Len;i++){
					var oneList="";
					var n=parseInt((i-1)*onePageNums);
					var k=n+parseInt(onePageNums);
					if (k>listLen) k=listLen;
					for (var listI=n;listI<k;listI++){
						var listIData=list.split(String.fromCharCode(2))[listI];
						if (listIData.indexOf("\\u0001")>=0){
							listIData=listIData.replace("\\u0001","")
						}
						if (oneList==""){
							oneList=listIData;
						}else{
							oneList+=String.fromCharCode(2)+listIData;
						}
					}
					DHC_PrintByLodop(getLodop(),txtPara,oneList,"","",{printListByText:true});
					//document.getElementById("ClsBillPrint").ToPrintHDLP(txtPara,oneList,docobj);
				}
			}else{
				DHC_PrintByLodop(getLodop(),txtPara,list,"","",{printListByText:true});
				//document.getElementById("ClsBillPrint").ToPrintHDLP(txtPara,list,docobj);
			}
			return true;
		//}
		return false;
	}
	
	function formatTxtData(targetPanel, jsonData, txtDataNode, itemCallBack) {
		var count = txtDataNode.childNodes.length;
		var html = [], item = [];
		var flag = itemCallBack && $.type(itemCallBack) === "function";
		var node = null;
		for (var i = 0; i < count; ++i) {
			delete item;
			item = [];
			node = txtDataNode.childNodes[i];
			if (node.nodeType=="3") continue; //�ı��ڵ� ��������
			item.push('<label ctrlType="label" id="' + genEleNewId("label")
					+ '"');
			item.push('name="' + node.getAttribute("name") + '"');
			item.push('style="position:absolute;white-space:nowrap;left:'
					+ convertPtToPx(node.getAttribute("xcol")) + 'px;top:'
					+ convertPtToPx(node.getAttribute("yrow")) + 'px;');
			if (node.getAttribute("fontsize") != "12") {
				item.push('font-size:' + node.getAttribute("fontsize") + 'pt;');
			}
			if (node.getAttribute("fontbold") != "false") {
				item.push('font-weight:bold;');
			}
			if (node.getAttribute("fontname") != "����") {
				item.push('font-family:' + node.getAttribute("fontname") + ';');
			}
			item.push('">');
			var printValue = jsonData[node.getAttribute("name")];
			if ((printValue)&&(!$.isArray(printValue))) {
				item.push(printValue.replace(/\s/g, "  "));
			} else if ($.trim((printValue = node.getAttribute("defaultvalue"))) != "") {
				item.push(printValue.replace(/\s/g, "  ").replace(/ /g,"&nbsp"));
			}
			item.push('</label>');
			if (flag) {
				html.push(itemCallBack(jsonData, item.join(''), node));
			} else {
				html.push(item.join(''));
			}
		}
		targetPanel.append(html.join(''));
		delete html;
		delete item;
	}
	function formatPLData(targetPanel, jsonData, plNode, itemCallBack) {
		var count = plNode.childNodes.length;
		var html = [], item;
		var bx = 0, by = 0, ex = 0, ey = 0, width = 0, height = 0;
		var node = null;
		var flag = itemCallBack && $.type(itemCallBack) === "function";
		for (var i = 0; i < count; ++i) {
			node = plNode.childNodes[i];
			if (node.nodeType=="3") continue; 
			delete item;
			item = [];
			item.push('<v:line ctrlType="shape" id="' + genEleNewId("shape")
					+ '" name="' + node.getAttribute("Name") + '" ');
			bx = convertPtToPx(node.getAttribute("BeginX"));
			by = convertPtToPx(node.getAttribute("BeginY"));
			ex = convertPtToPx(node.getAttribute("EndX"));
			ey = convertPtToPx(node.getAttribute("EndY"));
			width = ex - bx;
			height = ey - by;
			if (height == 0 && width != 0) {
				if (width > 0) {
					item
							.push('lineType ="1" style="POSITION: absolute; background:black; TOP:'
									+ by
									+ 'px; LEFT:'
									+ bx
									+ 'px;width:'
									+ width
									+ 'px;height:1px;"  from = "0,0" to = "'
									+ width
									+ 'px,0" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>');
				} else {
					item
							.push('lineType ="1" style="POSITION: absolute; TOP:'
									+ by
									+ 'px; LEFT:'
									+ ex
									+ 'px;width:'
									+ Math.abs(width)
									+ 'px;height:1px;"  from = "0,0" to = "'
									+ Math.abs(width)
									+ 'px,0" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>');
				}
			} else if (width == 0 && height != 0) {
				if (height > 0) {
					item
							.push('lineType ="2" style="POSITION: absolute; background:black; TOP:'
									+ by
									+ 'px; LEFT:'
									+ bx
									+ 'px;width:1px;height:'
									+ height
									+ 'px;"  from = "0,0" to = "0,'
									+ height
									+ 'px" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>');
				} else {
					item
							.push('lineType ="2" style="POSITION: absolute; background:black; TOP:'
									+ ey
									+ 'px; LEFT:'
									+ bx
									+ 'px;width:1px;height:'
									+ Math.abs(height)
									+ 'px;"  from = "0,0" to = "0,'
									+ Math.abs(height)
									+ 'px" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>');
				}
			} else if (height < 0 && width > 0) {
				height = by - ey;
				item
						.push('lineType ="3" style="POSITION: absolute; background:black; TOP:'
								+ ey
								+ 'px; LEFT:'
								+ bx
								+ 'px;width:'
								+ width
								+ 'px;height:'
								+ height
								+ 'px;"  from = "0,'
								+ height
								+ 'px" to = "'
								+ width
								+ 'px,0" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>');
			} else if (height > 0 && width < 0) {
				width = bx - ex;
				item
						.push('lineType ="3" style="POSITION: absolute; background:black; TOP:'
								+ by
								+ 'px; LEFT:'
								+ ex
								+ 'px;width:'
								+ width
								+ 'px;height:'
								+ height
								+ 'px;"  from = "0,'
								+ height
								+ 'px" to = "'
								+ width
								+ 'px,0" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>');
			} else if (height > 0 && width > 0) {
				item
						.push('lineType ="4" style="POSITION: absolute; background:black; TOP:'
								+ by
								+ 'px; LEFT:'
								+ bx
								+ 'px;width:'
								+ width
								+ 'px;height:'
								+ height
								+ 'px;"  from = "0,0" to = "'
								+ width
								+ 'px,'
								+ height
								+ 'px" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>');
			} else if (height < 0 && width < 0) {
				item
						.push('lineType ="4" style="POSITION: absolute; background:black; TOP:'
								+ ey
								+ 'px; LEFT:'
								+ ex
								+ 'px;width:'
								+ Math.abs(width)
								+ 'px;height:'
								+ Math.abs(height)
								+ 'px;"  from = "0,0" to = "'
								+ Math.abs(width)
								+ 'px,'
								+ Math.abs(height)
								+ 'px" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>');
			}
			if (flag) {
				html.push(itemCallBack(jsonData, item.join(''), node));
			} else {
				html.push(item.join(''));
			}
		}
			
		targetPanel.append(html.join(''));
		delete html, item;
	}
	function formatListData(targetPanel, jsonData, listDataNode, itemCallBack) {
		var html = [];
		var node = null;
		var ValidChildCount = 0;
		for (var i = 0; i < listDataNode.childNodes.length; ++i) {
			node = listDataNode.childNodes[i];
			var listNode = listDataNode.childNodes[i];
			if (listNode.nodeType=="3") continue; 
			ValidChildCount=ValidChildCount+1;
		}		
		html.push('<div ctrlType="list" id = "' + genEleNewId("list")+ '" ');
		html.push('CurrentRow="' + listDataNode.getAttribute("CurrentRow")+ '" ');
		if (listDataNode.getAttribute("PageRows") != "1") {
			html.push('PageRows="' + listDataNode.getAttribute("PageRows")+ '" ');
		}
		if (listDataNode.getAttribute("XStep") != "0") {
			html.push('XStep="' + listDataNode.getAttribute("XStep")+ '" ');
		}
		var pos = getStartXY(listDataNode);
		var padTop = 0;
		var yPosition = convertPtToPx(listDataNode.getAttribute("YStep")); //ValidChildCount* 
		html.push('style="position:absolute; margin:0; padding:0px;left:'
			+ pos[0]+ "px;top:" + (pos[1] + padTop + yPosition)
			+ 'px;width:' + (pos[2] + 100) + 'px;height:'
			+ convertPtToPx(listDataNode.getAttribute("YStep"))
			+ 'px;">');
		html.push('</div>');
		var $html=$(html.join(''));
		var $item=null;
		var $body=$("body");
		var sumXPos=0,outerHeight=0;
		var count = listDataNode.childNodes.length;
		for (var i = 0; i < count; ++i) {
			node = listDataNode.childNodes[i];
			var listNode = listDataNode.childNodes[i];
			if (listNode.nodeType=="3") continue; 
			var listName = listNode.getAttribute("name");
			listName="MyList";
			var listValue = jsonData[listName];
			if (($.type(listValue) === "array")&&(ValidChildCount>1)){
				for (var m=0;m<listValue.length;m++){
					sumXPos+=outerHeight;
					for (var j=i;j<count;j++){
						var tmpNode=listDataNode.childNodes[j];
						if (tmpNode.nodeType=="3") continue; 
						var tmplistName = tmpNode.getAttribute("name");
						if ($.type(listValue[m][tmplistName]) === "array") {
							listValue[m][tmplistName]=listValue[m][tmplistName][0];
						}
						$item=$(buildListItem(listValue[m][tmplistName], tmpNode,m));
						$item.css("top",sumXPos+parseInt($item.css('top')));
						$body.append($item);
						var itemH=$item.outerHeight();
						if (+itemH>0) outerHeight=$item.outerHeight();
						else  outerHeight=25;
						$item.remove();
						$html.append($item);
					}
				}
				break;
			}else{
				if (!listValue) continue;
				for ( var pro in listValue) {
					if (pro=="remove") continue;
					if ($.type(listValue) === "array") {
						for ( var pro1 in listValue[pro]) {
							$item=$(buildListItem(listValue[pro][pro1][0], node,+pro));
						}
					}else{
						$item=$(buildListItem(listValue[pro], node,+pro));
					}
					
					$item.css("top",sumXPos);
					$body.append($item);
					sumXPos+=$item.outerHeight();
					$item.remove();
					$html.append($item);
				}
			}
		}
		targetPanel.append($html);
		delete  html;
		function buildListItem(itemData, itemNode,index) {
			var html = [];
			html.push('<label ctrlType="label" id="' + genEleNewId("label")
					+ '" name="' + itemNode.getAttribute("name") + '" ');
			html.push('style="position:absolute;white-space:nowrap;line-height:25px;left:'
					+ (convertPtToPx(itemNode.getAttribute("xcol")) - pos[0])
					+ 'px;top:'
					+ (convertPtToPx(itemNode.getAttribute("yrow")) - pos[1])*(index+1)
					+ 'px;');
			if (itemNode.getAttribute("fontsize") != "12") {
				html.push('font-size:' + itemNode.getAttribute("fontsize")
						+ 'pt;');
			}
			if (itemNode.getAttribute("fontbold") != "false") {
				html.push('font-weight:bold;');
			}
			if (itemNode.getAttribute("fontname") != "����") {
				html.push('font-family:\'' + itemNode.getAttribute("fontname")
						+ '\';');
			}
			if (itemData.indexOf("\\u0001")>=0){
				html.push('color:red;');
				itemData=itemData.replace("\\u0001","")
				}
			html.push('"');
			if (!itemData) {
				if (jQuery.trim(itemNode.getAttribute("defaultvalue")) != "") {
					html.push('>' + itemNode.getAttribute("defaultvalue")
							+ '</label>');
				}else{
					html.push('>' +itemData.replace(/ /g,"&nbsp") + "</label>");
				}
			} else {
				//html.push('>' + (index+1)+"��"+itemData + "</label>");
				html.push('>' +itemData.replace(/ /g,"&nbsp") + "</label>");
			}
			return html.join('');
		}
	   
	}
	function getStartXY(xmlNode) {
		var count = xmlNode.childNodes.length;
		var startX = null;
		var startY = null;
		var endX = null;
		var endY = null;
		for (var index = 0; index < count; ++index) {
			var oneNode = xmlNode.childNodes[index];
			if (oneNode.nodeType=="3") continue; 
			var xcol = parseFloat(oneNode.getAttribute("xcol"), 10);
			var yrow = parseFloat(oneNode.getAttribute("yrow"), 10);
			if (startX == null) {
				startX = xcol;
			} else {
				if (xcol < startX) {
					startX = xcol;
				}
			}
			if (startY == null) {
				startY = yrow;
			} else {
				if (yrow < startY) {
					startY = yrow;
				}
			}

			if (endX == null) {
				endX = xcol;
			} else {
				if (xcol > endX) {
					endX = xcol;
				}
			}
			if (endY == null) {
				endY = yrow;
			} else {
				if (yrow > endY) {
					endY = yrow;
				}
			}
		}
		var result = [];
		result.push(convertPtToPx(startX));
		result.push(convertPtToPx(startY));
		result.push(convertPtToPx(endX - startX));
		result.push(convertPtToPx(endY - startY));
		return result;
	}
	function createXMLDOM() {
		for (var i = 0; i < ActiveXArr.length; i++) {
			try {
				return new ActiveXObject(ActiveXArr[i]);
			}catch(e){
				console.log(e);
				/*alert("��Ҫ��������Activex���ܽ��д�ӡ���á�����ActiveX���������\n"+
				"1�������Scripting.FileSystemObject (FSO �ı��ļ���д)���ر��ˣ�\n����FSO���ܼ��ɣ��ڡ����С���ִ��regsvr32 scrrun.dll����\n"
				+"2����ȫģʽ���óɡ��С������javascript�ű��б��������\n��Ӧ��IE�İ�ȫ���á�����������δ���Ϊ��ȫ��activeX�ؼ������ü��ɡ�\n"
				+'ע�����������Ӧ����վ���"�����ε�վ��",\n�����"�����ε�վ��"������Ӧ��IE��ȫ���ã���ʱ�����"Internet"IE���ý���ͽ�͵ġ�\n'
				+"3����Щ�ű���Ҫ΢��� MSXML �ؼ����ܽ��롣\n"
				+"");*/
			}
		}
		return null;
	}
	function genEleNewId(ele) {
		if (eleIdMap[ele]) {
			eleIdMap[ele]++;
		} else {
			eleIdMap[ele] = 1;
		}
		return ele + "_" + eleIdMap[ele];
	}
	function convertPtToPx(ptValue) {
		return subFloat((parseFloat(ptValue, 10)) * 3.78, 0);
	}
	function subFloat(num, v) {
	    var vv = Math.pow(10, v);
	    return Math.round(num * vv) / vv;
	}
	
	function joinJson(jsonData,strArr){
		var strArr=[];
		var arrArr=[];
		for(var pro in jsonData){
			if($.type(jsonData[pro]) === "array"){
				for(var ind in jsonData[pro]){
					if(($.type(jsonData[pro][ind]) === "array") || ($.type(jsonData[pro][ind]) === "function")){
						
					}else if ($.type(jsonData[pro][ind]) === "object"){
						var dataStr="",count=0;
						for(var pro1 in jsonData[pro][ind]){
							if (count==0) dataStr=jsonData[pro][ind][pro1][0];
							else dataStr=dataStr+"^"+jsonData[pro][ind][pro1][0];
							count=count+1;
						}
						arrArr.push(dataStr);
					}else{
						for (var m=0;m<jsonData[pro][ind].split("</br>").length;m++){
							arrArr.push(jsonData[pro][ind].split("</br>")[m].replace(/\&nbsp/g," "));
						}
						
					}
				}
			}else if($.type(jsonData[pro]) === "object"){
				//joinJson(jsonData[pro])
			}else{
				strArr.push(pro+String.fromCharCode(2)+jsonData[pro].toString().replace(/\&nbsp/g," "));
			}
		}
		return {
			"proValue":strArr.join('^'),
			"arrValue":arrArr.join(String.fromCharCode(2))
		};
	}
	function DrawBackSlash(targetPanel,BackSlashWidth,StartX,StartY,EndX,EndY){
		var html = [],item = [];
		var tmpid=genEleNewId("shape");
		item.push('<v:line ctrlType="shape" id="' + genEleNewId("shape")
					+ '" name="' + tmpid + '" ');
		item.push('lineType ="3" style="POSITION: absolute; background:black; TOP:'
				+ EndY
				+ 'px; LEFT:'
				+ EndX
				+ 'px;width:'+ BackSlashWidth
				+ 'px;height:1'
				+ 'px;"  from = "' + StartX + "px," + StartY
				+ 'px" to = "' + EndX +"px," +EndY
				+ 'px" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>');
		html.push(item.join(''));
		
		targetPanel.append(html.join(''));
		delete html, item;
	}
	function getPrinterList(){
		try{
			var oShell = new ActiveXObject("WScript.Shell");
    		sRegVal ='HKEY_CURRENT_USER\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Windows\\Device';
 			var sName = oShell.RegRead(sRegVal);
 			return sName.split(":");
			//console.log(sName);
		}catch(e){
			console.log(e);
			/*alert("��Ҫ��������Activex���ܽ��д�ӡ���á�����ActiveX���������\n"+
			"1�������Scripting.FileSystemObject (FSO �ı��ļ���д)���ر��ˣ�\n����FSO���ܼ��ɣ��ڡ����С���ִ��regsvr32 scrrun.dll����\n"
			+"2����ȫģʽ���óɡ��С������javascript�ű��б��������\n��Ӧ��IE�İ�ȫ���á�����������δ���Ϊ��ȫ��activeX�ؼ������ü��ɡ�\n"
			+'ע�����������Ӧ����վ���"�����ε�վ��",\n�����"�����ε�վ��"������Ӧ��IE��ȫ���ã���ʱ�����"Internet"IE���ý���ͽ�͵ġ�\n'
			+"3����Щ�ű���Ҫ΢��� MSXML �ؼ����ܽ��롣\n"
			+"");*/
		}
	}
	//��ͼƬת��Ϊhtml
	function xmlToImg(xmlNode,jsonData,targetPanel) {
	    var count = xmlNode.childNodes.length;
	    for (var index = 0; index < count; index++) {
	        var oneNode = xmlNode.childNodes[index];
	        var name=""
	        try{name=oneNode.getAttribute("name");}catch(e){name=""}
	        if (name==""){continue}
	        var cId = getNewCtrlId("img");
	        var ctrlHtml = "<img ctrlType='img' id='" + cId + "' name='" + name;
	        ctrlHtml = ctrlHtml + "' style='position:absolute;left:" + (convertPtToPx(oneNode.getAttribute("xcol"))+30)+ "px;top:" + convertPtToPx(oneNode.getAttribute("yrow")) + "px;' ";
		   	var printValue = jsonData[name];
			if( printValue!=""){
		        ctrlHtml = ctrlHtml +  "src='" + printValue + "' ";
		   	}else if (oneNode.getAttribute("defaultvalue") != "") {
	             ctrlHtml = ctrlHtml + "src='" + oneNode.getAttribute("defaultvalue") + "' ";
	      	}
			//ctrlHtml = ctrlHtml + "src='" + jsonData[name] + "' ";
	        ctrlHtml = ctrlHtml + " width='75px'  height='30px'/>";
	        targetPanel.append(ctrlHtml);
	        delete ctrlHtml;
	    }
	}
	//ȡ���¿ؼ�Id
	function getNewCtrlId(ctrlType) {
	    var index = 0;
	    while (true) {
	        index++;
	        var cId = ctrlType + index;
	        if (jQuery("#" + cId).length == 0) {
	            return cId;
	        }
	    }
	};
	return {
		"preview" : preview,
		"print":print,
		"getPrinterList":getPrinterList
	};
})();
