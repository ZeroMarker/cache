/**
 * 提供给不良事件打印调用
 * 需要支持runClassMethod方法
 */
 
/*
*打印方法，需要界面初始化Lodop打印
*Input:打印模板的code,赋值的json数据：json中name与模板ID对应
*		setObj:打印配置：
*/
function dhcprtPrint(prtCode,prtData,setObj){
	setObj = $.extend({"model":"print"},setObj);
	var ret = serverCall("web.DHCPRTMain","GetTmpData",{MACode:prtCode});
	PageWidth = ret.split("&&")[3]+"mm";
	PageHeight = ret.split("&&")[4]+"mm";
	ret = ret.split("&&")[7];
	if(ret==""){
		alert("模板获取错误!检查模板名称是否错误！");
		return;
	}
	
	if(!typeof(prtData) == 'object') {
		alert("打印入参错误,格式应为Object对象！");
		return;
	}
	LODOP = getLodop();
	LODOP.PRINT_INIT("CST PRINT");
	html = ret.saveOrShowDataFormat("show");
	html = html.prtDataFormatDom(prtData);
	html = html.prtDataFormat(prtData);
	html = html.prtClearHideDataFormat(prtData);
	
	console.log(html)
	LODOP.SET_PRINT_PAGESIZE(1,"210mm","297mm","A4")
	LODOP.ADD_PRINT_HTM(0,0,"RightMargin:0.9cm","BottomMargin:1cm",html);
	var prtRet="";
	if(setObj.model=="print"){
		prtRet=LODOP.PRINT();
	}else if(setObj.model=="view"){
		prtRet=LODOP.PREVIEW();
	}
	
	return prtRet;
}

///Descript:String扩展加载打印数据方法
String.prototype.prtDataFormat = function() {
	if(arguments.length == 0) return this;
	var param = arguments[0];
	var _s = this;
	_s = _s.replace(new RegExp("↓", "g"), "");
	
	if(typeof(param) == 'object') {
	for(var key in param)
		_s = _s.replace(new RegExp("\\[" + key + "\\]", "g"), param[key]);
	} else {
		for(var i = 0; i < arguments.length; i++)
		_s = _s.replace(new RegExp("\\[" + i + "\\]", "g"), arguments[i]);
	}
	_s = _s.replace(new RegExp("\\[.*?\\]", "g"), "");  ///未匹配值直接清空
	return _s;
}


///Descript:String扩展加载打印数据方法:用于向下扩展数据DOm操作
String.prototype.prtDataFormatDom = function() {
	if(arguments.length == 0) return this;
	var param = arguments[0];
	var _s = this;
	_s = _s.replace(new RegExp("↓", "g"), "");
	
	parser = new DOMParser();
	doc = parser.parseFromString(_s, "text/html"); 
	
	_l=doc.getElementsByClassName("extendTr").length;
	for (i=0;i<_l;i++){
		_id=doc.getElementsByClassName("extendTr")[0].getAttribute("id");
		_nh = doc.getElementsByClassName("extendTr")[0].outerHTML;
		if(typeof(param[_id])=="object"){
			_i=param[_id].length;
			for(j=1;j<_i;j++){
				$(doc.getElementsByClassName("extendTr")[0],doc).after(_nh);
			}
			
			for (i in param[_id]){
				for (j in param[_id][i]){
					if($("td[id='"+j+"']",doc)[i]){
						$("td[id='"+j+"']",doc)[i].innerHTML=param[_id][i][j];
					}
				}
			}
			doc.getElementsByClassName("extendTr")[0].removeAttribute("class");
		}
	}
	return $("body",doc).html();
}

String.prototype.prtClearHideDataFormat=function(){
	var _s = this;
	parser = new DOMParser();
	doc = parser.parseFromString(_s, "text/html"); 
	$("td[style*='display']",doc).remove();
	return $("body",doc).html();
}


///Descript:保存方法字段过长，替换大量重复字符为固定格式
String.prototype.saveOrShowDataFormat = function() {
	if(arguments.length == 0) return this;
	var param = arguments[0];
	var _s = this;
	if(param=="save"){
		_s=_s.replace(new RegExp('<td class="p-itmp" style="font-size:4mm;box-sizing: border-box;border-left:1px solid #000;border-top:1px solid #000;',"g"),'Ms.H');
	}else if(param=="show"){
		_s=_s.replace(new RegExp('Ms.H',"g"),'<td class="p-itmp" style="font-size:4mm;box-sizing: border-box;border-left:1px solid #000;border-top:1px solid #000;');
	}
	return _s;
}



