/**
 * @ Huxiaotian 2018-04-30  GB2312编码
 * @ 提供方法: 文件的下载与读取
 *  downloadFiles(url) //下载服务器文件
 *  readLocalFiles(callBackFn,suffix) //创建文件框,读取本地文件
 *	loadScript("xlsx_full_min_js","../scripts/filehandingutiljs/xlsx.full.min.js",function(){}) //动态加载js文件
 *  -----export excel----
 *	downloadExcelSimple(jsonResult,needTitle) //ie环境下导出简单的Excel文件
 *	downloadExcel(data, title, fileName) //使用xlsx.full.min.js导出Excel, 效率高
 *  exportDataToExcel({servercsp:'',postdata:{},title:{}}) //exportJsonToExcel基础上做了优化(******)
 *  exportJsonToExcel(data,title,fileName) //兼容ie和其他浏览器的导出方案, 不依赖于任何插件
 *  -----read excel-----
 *	jsReadFiles(function(result){//do something here with result}) //读取本地文本文件和图片文件
 *	jsReadExcelAsJson(function(result){//do something here with result}) //读取Excel文件解析为json数组
 *	readLocalExcel() //读取本地的Excel文件返回json对象
 *  -----xml------
 *	loadXML(xmlFileUrl) //把服务器的xml加载到js中, 返回的是xml对象
 *	jsReadLocalXML(function(result){//do something here with result}) //读取本地的xml文件作为字符串, 再把字符串转化为xml对象
 *	xmlStrToXmlObj(str) //xml字符串转化为xml文档对象
 *  -----ajax------
 *	getJsonByClassMethod(className,methodName) //后台类方法w输出的json字符串转化为json对象
 *  jsRunClassMethod(className,methodName) //js中获取类方法的返回值
 *  asyRunClassMethod({}) //异步访问类方法
 *	ajax(options) //原生js封装ajax, 在组件开发中可以使用
 * @ Others: 
 */
//-------------------------------------------------------------------------------------------
//文件下载方法
//url : ../Results/Template/longObjectFile.xls
function downloadFiles(url){
	var a = document.createElement("a");
	a.setAttribute("download","");
	a.setAttribute("href",url);
	document.body.appendChild(a);
	a.click(); //模拟点击
	a.parentNode.removeChild(a);
	
	/*
	var f = document.createElement("form");
	f.setAttribute("method","GET");
	f.setAttribute("action",url);
	document.body.appendChild(f);
	f.submit();
	f.parentNode.removeChild(f);
	*/
	
	/*
	try{ 
    	var elemIF = document.createElement("iframe");   
        elemIF.src = url;   
        elemIF.style.display = "none";   
        document.body.appendChild(elemIF);   
    }catch(e){
	    alert(e);
    }
    */
}

//如何实现文件的上传?????????????????????????
function uploadFiles(url) {
	/* FormData 是表单数据类 */
	var fd = new FormData();
	var ajax = new XMLHttpRequest();
	fd.append("upload", 1);
	/* 把文件添加到表单里 */
	fd.append("upfile", document.getElementById("fb").files[0]);
 	ajax.open("post", url, true); 
 	ajax.onload = function () {
 		console.log(ajax.responseText);
 	};
 	ajax.send(fd);
 	console.log(fd);
}

//Desc: 创建文件框,读取本地文件
//Input: callBackFn - 回到函数, 会把用户选择的文件作为参数传递给回到函数
function readLocalFiles(callBackFn,suffix){
	//动态创建文件输入表单(不需要在页面上再单独加一个input)
	var inputFileBox = document.createElement("input");
	inputFileBox.type="file";
	inputFileBox.onchange=function(){
		//jsReadFiles(this.files); /*读取文本文件和图片文件*/
		//jsReadExcelAsJson(this.files); /*读取Excel文件*/
		//jsReadLocalXML(this.files); /*按文本读取xml*/
		var files = this.files;
		if((suffix)&&(files[0].name.indexOf(suffix)<=0)){
			alert("文件格式错误,请选择后缀为: "+suffix+" 的文件!");
			return;
		}
		if(callBackFn){
			callBackFn(files);
		}
	}
	document.body.appendChild(inputFileBox);
	inputFileBox.click();
	return;
}

//在需要的时候, 动态加载js文件
//scripts/filehandingutiljs/xlsx.full.min.js
//loadScript("xlsx_full_min_js","filehandingutiljs/xlsx.full.min.js",function(){})
function loadScript(jsId, jsUrl, callback){
	var head= document.getElementsByTagName('head')[0]; 
	var script= document.createElement('script');
	script.id = jsId;
	script.type = 'text/javascript'; 
	script.onreadystatechange = function () {
		if (this.readyState == 'complete') {
			//callback();
		}	
	} 
	script.onload = function(){
		callback();
	}
	script.src= jsUrl; 
	head.appendChild(script);
}

/**
 * @ Excel导出方案 (一) ------------------------
 */
// Huxiaotian 2018-04
// Desc: 把从后台获取的json串导出为Excel文档, 仅支持IE并需要安装Excel
// Input: jsonResult - json对象(不是字符串), 如:[{"name":"Huxiaotian","age":25},{"name":"Huxiaotian2","age":26}]
//        needTitle - json中需要导出列的key 组成的数组(如果没有传入,默认全部列), 如: {"name":"姓名","age":"年龄"}
// Output: Excel
// Others: 该方法使用于数据比较少的(最多几百条),如果数据较多容易卡死
function downloadExcelSimple(jsonResult,needTitle) {
	if(jsonResult.length<1){
		alert("没有数据, 无法导出!");
		return;
	}
	var need_title = null;
	for (var i=1; i<downloadExcelSimple.arguments.length; i++) {
		need_title = downloadExcelSimple.arguments[i];
	}
	try{
		//创建模板
		var oXL = new ActiveXObject("Excel.Application"); 
		var oWB = oXL.Workbooks.Add(); 
		var oSheet = oWB.ActiveSheet;
		if (need_title) {
			//设置标题
			var k=0;
			for (var t in need_title){
				oSheet.Cells(1,k+1).value = need_title[t];
				k=k+1;
			}
			//填写数据
			var rows = jsonResult.length; //行数
			for (var i=0;i<rows;i++){
				var j=0;
				for (var tt in need_title){
					if(tt in jsonResult[i]){
						oSheet.Cells(i+2,j+1).value = jsonResult[i][tt];
						j=j+1;
					}
				};
			}
		} else {
			//设置标题
			var k=0;
			for (var title in jsonResult[0]){
				oSheet.Cells(1,k+1).value = title;
				k=k+1;
			}
			//填写数据
			var rows = jsonResult.length; //行数
			for (var i=0;i<rows;i++){
				var j=0;
				for (var key in jsonResult[i]){
					oSheet.Cells(i+2,j+1).value = jsonResult[i][key];
					j=j+1;
				}
			}
		
		}
		//导出--->1
		//oXL.Visible = true; 
		//oXL.UserControl = true;
		//导出--->2
        var fname = oXL.Application.GetSaveAsFilename("Excel.xls", "Excel Spreadsheets (*.xls), *.xls");
	}catch(e){
		alert(e+"\n"+"请使用IE浏览器,安装Office2003及以上版本,并允许浏览器运行Active控件!");
		console.log(e+"\n"+"请使用IE浏览器,安装Office2003及以上版本,并允许浏览器运行Active控件!");
		print("Nested catch caught " + e);
	}finally{
		//xls.Visible = false;
		oWB.SaveAs(fname);
		oWB.Close(savechanges = false);
        oXL.Quit();
        oXL = null;
	}
}

//json对象的遍历测试
function testSomething(){
	var json = [{"dd":'SB',"AA":'东东',"re1":123},{"cccc":'dd',"lk":'1qw'}];
	for(var i=0,l=json.length;i<l;i++){
		for(var key in json[i]){
			console.log(key);
　　　　	//console.log(key+':'+json[i][key]);
　　	}
	}
}

// Add By Huxiaotian 2018-04
// Desc: Json串导出为Excel文件, ie google兼容支持
// Input: data - json对象
//        title - json中需要导出的列及其中文含义, 如:{"name":"姓名","age":"年龄"}, 如果需要导出所有列则传入 - null
//        fileName - 文件名, 如: xxxxxx.xlsx
//        sheetName - 同一个Excel文件中的sheet名, 如: sheet1
// Output: Excel
// Others: 优化: 原方法中IE不支持Object.assign()克隆和合并对象,注释掉有Object.assign()代码的部分
//         该方法需要引入外部js文件FileSaver.min.js和xlsx.full.min.js, 导出文件的效率高
function downloadExcel(data, title, fileName) {
	//1. 定义js加载完成后调用的函数
	var doLoadExcel = function(){
		if(title){
			var keys = Object.keys(title);
			var firstRow = {};
			keys.forEach(function (item) {
				firstRow[item] = title[item];
			});
		}else{
			var keys = Object.keys(data[0]);
			var firstRow = {};
			keys.forEach(function (item) {
				firstRow[item] = item;
			});
		}
		data.unshift(firstRow);
		
		var content = {};
		try{
			// 把json格式的数据转为excel的行列形式
			var sheetsData = data.map(function (item, rowIndex) {
				return keys.map(function (key, columnIndex) {
					if(title){
						if(key in title){
							/*return Object.assign({}, {
								value: item[key],
								position: (columnIndex > 25 ? getCharCol(columnIndex) : String.fromCharCode(65 + columnIndex)) + (rowIndex + 1),
							});*/
							return {
								value: item[key],
								position: (columnIndex > 25 ? getCharCol(columnIndex) : String.fromCharCode(65 + columnIndex)) + (rowIndex + 1),
							};
						}
					}else{
						/*return Object.assign({}, {
							value: item[key],
							position: (columnIndex > 25 ? getCharCol(columnIndex) : String.fromCharCode(65 + columnIndex)) + (rowIndex + 1),
						});*/
						return {
							value: item[key],
							position: (columnIndex > 25 ? getCharCol(columnIndex) : String.fromCharCode(65 + columnIndex)) + (rowIndex + 1),
						};
					}
					
				});
			}).reduce(function (prev, next) {
				return prev.concat(next);
			});
			//console.log(sheetsData);
			
			sheetsData.forEach(function (item, index) {
				if(item){
					content[item.position] = { v: item.value };
				}
			});

			//设置区域,比如表格从A1到D10,SheetNames:标题
			var coordinate = Object.keys(content);
			var CellsZone = {"!ref":coordinate[0] + ":" + coordinate[coordinate.length - 1]};
			var workBook = {
				SheetNames: ["Sheet1"],
				Sheets: {
					"Sheet1" : extend(content,CellsZone) //Object.assign({}, content, { "!ref": coordinate[0] + ":" + coordinate[coordinate.length - 1] })
				}
			};
			//console.log(workBook);
			
			//这里的数据是用来定义导出的格式类型
			var excelData = XLSX.write(workBook, { bookType: "xlsx", bookSST: false, type: "binary" });
			var blob = new Blob([string2ArrayBuffer(excelData)], { type: "" });
			saveAs(blob, fileName); // scripts/filehandingutiljs/FileSaver.min.js
		}catch(e){
			alert(e);
		}
	}
	
	//2. 动态加载js:xlsx.full.min.js
	var jsId = "xlsx_full_min_js";
	var jsUrl = "../scripts/filehandingutiljs/xlsx.full.min.js";
	var doLoadjs = (function(){
		loadScript(jsId,jsUrl,doLoadExcel);
	})()
}

//字符串转字符流
function string2ArrayBuffer(s) {
	var buf = new ArrayBuffer(s.length);
	var view = new Uint8Array(buf);
	for (var i = 0; i != s.length; ++i) view[i] = s.charCodeAt(i) & 0xFF;
	return buf;
}

// 将指定的自然数转换为26进制表示。映射关系：[0-25] -> [A-Z]。
function getCharCol(n) {
	let temCol = "",
		s = "",
		m = 0
	while (n > 0) {
		m = n % 26 + 1
		s = String.fromCharCode(m + 64) + s
		n = (n - m) / 26
	}
	return s
}

//合并对象,原方法中IE不支持Object.assign()方法合并对象
function extend(target, source) {
	for (var obj in source) {
    	target[obj] = source[obj];
    }
    return target;
}

/* 
 * @ Excel导出方案 (二) ------------------------
 * Huxiaotian 2018-05
 */
// Huxiaotian 2018-05-07
// 导出Excel文件,简化方法:
// 只需要传入url, 请求参数, 需要导出的title; 但是请求的url必须返回json字符串
/** Example:
	exportDataToExcel({
		servercsp:'xxx.csp',
		postdata:{actiontype:"",params:""},
		title:{}
	});
*/
function exportDataToExcel(opt){
	opt = opt || {};
	opt.servercsp = opt.servercsp;
	opt.postdata = opt.postdata || {};
	opt.title = opt.title || {};
	opt.filename = opt.filename || "下载文件.xls";
	
	var fileName;
	if(browserIsIE()){
		fileName = getFileName(); //IE浏览器使用Active控件创建文件名
	}else{
		fileName = opt.filename; //非IE浏览器文件命名,用户传入或者默认文件名
	}
	
	ajax({
        url: opt.servercsp,   //请求地址
        type: "GET",          //请求方式
        data: opt.postdata,   //请求参数
        dataType: "json",     //返回的数据类型
        success: function (response, xml) {
            try{
	            var ret = JSON.parse(response);
	        }catch(e){
		        alert(e+"\n"+"JSON数据转换失败! 请检查数据格式或浏览器是否支持JSON.parse()函数");
		        return;
		    }
		    //console.log(ret);
            exportJsonToExcel(ret, opt.title, fileName);
            alert("导出Excel成功!");
        },
        fail: function (status) {
            // 此处放失败后执行的代码
            alert("请求失败!");
        }
    });
    
    return;
}

//兼容ie与其他浏览器的导出方法
//Input: data - 使用异步加载获取数据
//       title - 在js中声明
//       fileName - 在获取data之前使用getFileName()获取, 需要先注册MSCommonDialog.reg
//Others: 
function exportJsonToExcel(data,title,fileName){
	if(browserIsIE()){
		ExportForIE(data,title,fileName); //ie允许运行active, 读写文件
	} else {
		ExportForOthers(data,title,fileName); //浏览器支持data协议, ie不支持
	}
}

//IE浏览器导出方法, 读写本地文件
//data: [{},{},{}]
//title: {}
//fileName: "C:\\Users\\Administrator\\Desktop\\这是测试文件.xls"
//ExportForIE(data,title,"C:\\Users\\Administrator\\Desktop\\这是测试文件.xls")
function ExportForIE(data,title,fileName){
	if(!fileName){
		fileName = getFileName();
	}
	try{
		var fso = new ActiveXObject("Scripting.FileSystemObject");
		var sTextfile = fso.CreateTextFile(fileName,true,true);
		
		//Excel第一行存放标题
		var DelimCol=String.fromCharCode(9);
		var xlsTitleStr = "";
		var cols = title.length;
		for (var k in title){
			if(k in data[0]){
				if (xlsTitleStr=="") {
					xlsTitleStr=title[k];
				} else {
					xlsTitleStr = xlsTitleStr + DelimCol + title[k];
				}
			}
		}
		sTextfile.WriteLine(xlsTitleStr);
		
		//第二行开始放数据
		var rows = data.length;
		for (var m=0;m<rows;m++){
			var xlsDataStr = "";
			for (var n in title){
				if(data[m][n]){
					if(xlsDataStr==""){
						xlsDataStr = data[m][n];
					}else{
						xlsDataStr = xlsDataStr + DelimCol + data[m][n];
					}
				}
			}
			sTextfile.WriteLine(xlsDataStr);
		}
		sTextfile.Close();
   		sTextfile=null;
    	fso=null;
	}catch(e){
		alert(e);
	}
}

//其他浏览器导出方法,该方法不支持IE导出Excel
function ExportForOthers(data,title,fileName){
	var table=getHtmlTableStr(data,title);
	/*定义url*/
	var uri = 'data:application/vnd.ms-excel;base64,',
	/*定义html字符串*/
    template = '<html><head><meta charset="UTF-8"></head><body>'+table+'</body></html>',
	/*定义base64处理函数*/
    base64 = function(s) { return window.btoa(unescape(encodeURIComponent(s))) }
	/*返回函数:自调用*/
    return (function() {
    	window.location = uri + base64(template); //浏览器对url的长度有限制,如果url超长将导致无法下载
    	//window.location.href = uri + base64(template);
    	/*
    	var a = document.createElement("a");
		a.setAttribute("download",fileName); //这种方法可以指定下载文件的名称,但不能指定保存路径
		a.setAttribute("href",uri + base64(template));
		document.body.appendChild(a);
		a.click(); //模拟点击
		a.parentNode.removeChild(a);
		*/
    })()
}

//使用数据拼接html的table标签字符串
//可以通过设置标签的属性来设置Excel表格的格式
function getHtmlTableStr(data,title){
	var theadHtml = "";
	//set title --------->
	var cols = title.length;
	for (var k in title){
		if(k in data[0]){
			if (theadHtml=="") {
				theadHtml = '<thead><tr><th>'+title[k]+'</th>';
			} else {
				theadHtml = theadHtml+'<th>'+title[k]+'</th>';
			}
		}
	}
	theadHtml = theadHtml+'</tr></thead>';
	//set data list ---------->
	var tbodyHtml = "";
	var rows = data.length;
	console.log(rows);
	for (var m=0;m<rows;m++){
		var oneRow = "";
		for (var n in title){
			//只找需要的列
			if(n in data[m]){
				if(oneRow==""){
					oneRow = '<tr><td>' + data[m][n] + '</td>';
				}else{
					oneRow = oneRow + '<td>' + data[m][n] + '</td>';
				}
			}
		}
		oneRow = oneRow + '</tr>'
		if(tbodyHtml==""){
			tbodyHtml = '<tbody>' + oneRow;
		}else{
			tbodyHtml = tbodyHtml + oneRow;
		}
	}
	tbodyHtml = tbodyHtml + '</tbody>';
	return '<table cellspacing="0" border="1">'+theadHtml+tbodyHtml+'</table>';
}

//判断是否是IE,仅IE支持ActiveXObject
function browserIsIE() {   
    if (!!window.ActiveXObject || "ActiveXObject" in window) { 
    	return true;
    } else {
	    return false;
	}
}

//用户在弹窗中选择文件的保存路径和输入文件的名称
//返回如: C:\Users\Administrator\Desktop\1111.xls
function getFileName(){
	var fileName="";
	try {	
		var mscd = new ActiveXObject("MSComDlg.CommonDialog");
		mscd.Filter = "Microsoft Office Excel(*.xls)|*.xls";
		mscd.FilterIndex = 1;
		// 必须设置MaxFileSize. 否则出错
		mscd.MaxFileSize = 32767;
		// 显示对话框
		mscd.ShowSave();
		fileName=mscd.FileName;
		mscd=null;
	} catch(e) {
		if (confirm("当前系统不支持创建路径,是否载入文件配置?\n载入成功后,重启浏览器生效!")){
			var fso = new ActiveXObject("Scripting.FileSystemObject");
			var sTextfile = fso.CreateTextFile("C:\\MSCommonDialog.reg",true)
			sTextfile.WriteLine("Windows Registry Editor Version 5.00")
			sTextfile.WriteLine("[HKEY_CLASSES_ROOT\\Licenses\\4D553650-6ABE-11cf-8ADB-00AA00C00905]")
			sTextfile.WriteLine("@=\"gfjmrfkfifkmkfffrlmmgmhmnlulkmfmqkqj\"")
			sTextfile.Close();
			sTextfile=null;
			fso=null;
			var shell = new ActiveXObject("WScript.Shell"); 
			shell.Run("C:\\MSCommonDialog.reg");
			return;
		}else{
			return;					
		}
	}
	return fileName;
}

//该方法只返回文件保存的路径
//返回如: C:\Users\Administrator\Desktop
function getFilePath() {
	try {
		var shell = new ActiveXObject("Shell.Application");
		//var folder = shell.BrowseForFolder(0, '请选择存储目录', 0x0040, 0x11); //初始位置: 我的电脑
		var folder = shell.BrowseForFolder(0, '请选择存储目录', 0); //初始位置: 桌面
		var filePath;
		if (folder != null) {
			if (folder == "桌面") {
				var shell_2 = new ActiveXObject('WScript.Shell');
				filePath = shell_2.ExpandEnvironmentStrings('%UserProfile%\\Desktop');
				//filePath = "C:\\Users\\Administrator\\Desktop"; //桌面路径
			} else {
				filePath = folder.Items().Item().Path;
			}   
		}
		return filePath;
	}catch (e) {
		//alert("请选择桌面的文件夹后，再进行下载");
		alert(e.message);
	}
}

/* -------------------------------------------------------------------------------------
 * FileReader共有4种读取方法：(html5 - 只支持ie8及以上版本)
 * 1.readAsArrayBuffer(file)：将文件读取为ArrayBuffer。
 * 2.readAsBinaryString(file)：将文件读取为二进制字符串(ie不支持)
 * 3.readAsDataURL(file)：将文件读取为Data URL
 * 4.readAsText(file, [encoding])：将文件读取为文本，encoding缺省值为'UTF-8'
 */
//读取文本文件和图片文件
function jsReadFiles(callbackFn){
	//选择文件后, 执行读取操作函数定义
	var doReadFile = function(files){
		if (files.length) {
			var file = files[0];
			var reader = new FileReader();/*FileReader实例, 仅ie8及其以上的版本才支持*/
			if (/text+/.test(file.type)) {
				reader.onload = function() {
					//alert(this.result);
					//return this.result; //异步执行返回无效,使用回调函数
					if(callbackFn){
						callbackFn(this.result);
					}
				}
				reader.readAsText(file,'gb2312'); /*读取文本文件*/
				//reader.readAsText(file,'utf-8');
			} else if(/image+/.test(file.type)) {
				reader.onload = function() {
					$('body').append('<img src="' + this.result + '"/>');
				}
				reader.readAsDataURL(file); /*读取图片文件*/
			}
		}
	}
	
	//执行读取
	readLocalFiles(doReadFile);
}

//------------------>
//把Excel文件解析为json对象, ie/google都行
//依赖于: filehandingutiljs/xlsx.full.min.js, 考虑到效率问题,我决定使用js动态加载的方式,在需要的时候加载,这样就不影响原网页的初始化效率
//使用内部函数(闭包),可以直接访问最外层函数的参数
function jsReadExcelAsJson(callFn){
	//1. 读取前 动态加载js:xlsx.full.min.js
	var jsId = "xlsx_full_min_js";
	var jsUrl = "../scripts/filehandingutiljs/xlsx.full.min.js";
	loadScript(jsId, jsUrl, function(){
		//readLocalFiles(doReadExcel); //创建文件框,读取文件,异步加载后click事件会失效
	});
	
	//2. 执行读取操作函数定义
	var doReadExcel = function (files){
		var wb; //读取完成的数据
		var rABS = true; //是否将文件读取为二进制字符串
		if(!files) {
			alert("请选择文件!");
			return;
		}
		var f = files[0];
		var reader = new FileReader(); //ie8 google
		//读取完成后执行 ----->
		reader.onload = function(e) {
			var xlsx = document.getElementById("xlsx_full_min_js");
			if(!xlsx){
				alert("核心js未加载完成,请稍后再试!");
				return;
			}
			var data = e.target.result;
			if(rABS) {
				wb = XLSX.read(btoa(fixdata(data)), {//手动转化
					type: 'base64'
				});
			} else {
				wb = XLSX.read(data, {
					type: 'binary'
				});
			}
			//wb.SheetNames[0]是获取Sheets中第一个Sheet的名字
			//wb.Sheets[Sheet名]获取第一个Sheet的数据
			//var jsonStr = JSON.stringify( XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]]) ); //对象转换为字符串
			var jsonObj = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]]);
			//console.log(jsonObj);
			//alert(jsonObj);
			//return jsonObj; /*由于是异步读取的, 无法直接使用返回值, 只能使用回调函数*/
			if(callFn){
				callFn(jsonObj);
			}
		};
		
		//执行读取文件数据 ----->
		if(rABS) {
			reader.readAsArrayBuffer(f);
		} else {
			reader.readAsBinaryString(f);
		}
	}
	
	//3. 动态创建文件文件框,并把文件传递给回调函数
	readLocalFiles(doReadExcel,".xls");
	return;
}

//文件流转BinaryString
function fixdata(data) {
	var o = "", l = 0, w = 10240;
	for(; l < data.byteLength / w; ++l) o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w, l * w + w)));
	o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w)));
	return o;
}

function readLocalExcel(){
	var fileName = getFileName();
	try{
		var xlsApp = new ActiveXObject("Excel.Application");
	}catch(e){
		alert("warning","必须安装excel，同时浏览器允许执行ActiveX控件");
		return false;
	}
	try{
		var xlsBook = xlsApp.Workbooks.Open(fileName);
		var xlsSheet = xlsBook.Worksheets(1);		//ps: 使用第一个sheet
		var ret = ReadDataAsJson(xlsApp, xlsBook, xlsSheet); //读取一行
	}catch(e){
		alert(e);
		alert('error', '读取Excel失败:' + e);
	}
	xlsApp.Quit();
	xlsApp = null;
	xlsBook = null;
	xlsSheet = null;
	return ret;	//结束Excel进程,返回数据
	return;
}
function ReadDataAsJson(xlsApp, xlsBook, xlsSheet){
	var rowsLen = xlsSheet.UsedRange.Rows.Count;
	var colsLen = xlsSheet.UsedRange.Columns.Count;
	var arr = [];
	var StartRow = 1; //第2行开始
	for(var i = StartRow; i < rowsLen; i++){
		var rowData = {};
		for(var j = 0; j < colsLen; j++){
			var CellContent = xlsSheet.Cells((i + 1), (j + 1)).value;
			CellContent = typeof(CellContent)=='undefined'? '' : CellContent;
			/*
			if(!Ext.isEmpty(CellContent) && typeof(CellContent) == 'date'){
				CellContent = new Date(CellContent).format('Y-m-d');
			}
			*/
			var k = j+1;
			rowData["cols"+k] = CellContent;
		}
		arr.push(rowData);
	}
	return arr;
}

//---------------------------------------------------------------------
/* loadXML(xmlFileUrl)
 * jsReadLocalXML(callBackFn)
 * xmlStrToXmlObj(str)
 */
//Desc: 服务器加载xml文档到内存中, 并解析为xml文档对象
//Date: 2018-04-29
//Input: xmlFileUrl - 服务其中xml文件的路径位置
//Output: xml文档对象(类似于html对象)
function loadXML(xmlFileUrl) {
	var xmlDoc;
	if (window.ActiveXObject) {
		//alert("ie"); //IE浏览器(为什么我的ie不行????)
	    var xmlDomVersions = ['Microsoft.XMLDOM','MSXML.2.DOMDocument.6.0','MSXML2.DOMDocument.4.0','MSXML.2.DOMDocument.3.0'];  
        for(var i=0;i<xmlDomVersions.length;i++){  
            try{  
                xmlDoc = new ActiveXObject(xmlDomVersions[i]); //判断当前浏览器支持什么版本
                break;  
            }catch(err){  
            }
        }
		xmlDoc.async = false;
		xmlDoc.load(xmlFileUrl);
	} else if (isFirefox=navigator.userAgent.indexOf("Firefox")>0) { 
		//alert("firefox"); //火狐浏览器
		//else if (document.implementation && document.implementation.createDocument) {}
		xmlDoc = document.implementation.createDocument('', '', null);
		xmlDoc.load(xmlFileUrl);
	} else {
		//alert("google"); //google浏览器
		var xmlhttp = new window.XMLHttpRequest();
		xmlhttp.open("GET",xmlFileUrl,false);
		xmlhttp.send(null);
		if(xmlhttp.readyState == 4){
			xmlDoc = xmlhttp.responseXML; //支持ie11和google
		} 
	}
	if (xmlDoc == null) {
		alert('您的浏览器不支持xml文件读取,于是本页面禁止您的操作,推荐使用IE5.0以上可以解决此问题!');
		window.location.href = '../err.html';
	}
	//xmlDoc.documentElement ---> xml文档的根节点
	console.log(xmlDoc);
	return xmlDoc; 
}

//Desc: js读取本地的xml文件,并把xml对象作为参数传递给回调函数callBackFn, 在回调函数中可以解析xml文档对象的数据
//Input: callBackFn - 回调函数,回调函数只可以对xml文档对象进行操作
//Output: 
function jsReadLocalXML(callBackFn){
	var inputFileBox = document.createElement("input");
	inputFileBox.type="file";
	inputFileBox.onchange=function(){
		//----------------------------
		var files=this.files;
		var file = files[0];
		var reader = new FileReader(); /*仅ie8及其以上的版本才支持*/
    	reader.onload = function() {
	    	//alert(this.result);
	    	var xmlDocObj = xmlStrToXmlObj(this.result); //调用解析字符串的方法
	    	console.log(xmlDocObj.documentElement);
	    	if(callBackFn){
		    	callBackFn(xmlDocObj);
			}
    	}
    	//reader.readAsText(file,'gb2312'); /*读取文本文件*/
    	reader.readAsText(file,'utf-8');
    	//----------------------------
	}
	document.body.appendChild(inputFileBox);
	inputFileBox.click();
}

//Desc: js解析xml字符串为对象,ie11以下不支持
//Input: xml字符串
//Output: xml文档对象
function xmlStrToXmlObj(str){
    var allowIE = false; //是否允许ie, 暂时写死
    try{
	    if((browserIsIE()==true)&&(allowIE==true)){
	    	alert("ie");
	    	var xmlDoc;
	    	var xmlDomVersions = ['Microsoft.XMLDOM','MSXML.2.DOMDocument.6.0','MSXML2.DOMDocument.4.0','MSXML.2.DOMDocument.3.0'];  
        	for(var i=0;i<xmlDomVersions.length;i++){  
            	try{  
                	xmlDoc = new ActiveXObject(xmlDomVersions[i]); //判断当前浏览器支持什么版本
                	break;  
            	}catch(err){  
            	}
        	}
	    	xmlDoc.loadXML(str); //区别: xmlDoc.load(url); xmlDoc.loadXML(str)
	    	return xmlDoc;
		}else{
			alert("g");
			var parser=new DOMParser();
    		var xmlDoc=parser.parseFromString(str,"text/xml");
    		return xmlDoc;
		}
	} catch (e) {
		alert(e+":"+"请使用IE11或谷歌浏览器")
	}
}

//测试 获取xml文档对象中的值
//xmlDoc : xml文档对象(类似于加载到内存中的html标签)
function testXmlRead(xmlDoc){
	//提取数据  
    var banks = xmlDoc.getElementsByTagName('bank');
    for (var i = 0; i < banks.length; i++) {  
        //console.log(banks[i].textContent);  
        if(banks[i].attributes["bankName"]){
	        console.log(banks[i].attributes["bankName"].value);
	    }
    }
}

//js导出xml文件到本地：ie & google --> 在服务器端使用M生成xml,再使用文件下载的方式下载到本地

//---------------------------------------------------------------------


/*
 * Huxiaotian 2018-04
 * Desc: 获取后台数据, 类似于tkMakeServerCall()
 *       当在类方法中不是用-q返回值-而是使用-w返回值-的时候,使用该方法
 * Input: 
 *     className - 类名,
 *     methodName - 方法名,
 *     其他 - 参数列表(参数的个数必须与ClassMethod的参数个数一致,否则容易出错)
 * Output: Json对象,不是字符串
 * Others: 请求的路径是: dthealth/web/csp/dhcst.getjsonbyclassmethod.csp (使用前必须引入该csp,否则该方法无效)
 *         该方法和tkMakeServerCall()一样, 是同步加载的, 及该方法执行完成后才能执行后面的代码
 */
function getJsonByClassMethod(className,methodName){
	try{
		var argStr = "";
		var parLen=getJsonByClassMethod.arguments.length;
		for (var i=2; i<parLen; i++) {
			if(i==2){
				argStr = getJsonByClassMethod.arguments[i];
			}else{
				argStr = argStr + "|@|" + getJsonByClassMethod.arguments[i];
			}
		}
		if(parLen==2){
			argStr = "noparams";
		}
		if((argStr=="")&&(parLen==3)){
			argStr = "nullparam";
		}
		
		if (window.XMLHttpRequest) {
        	var xhr = new XMLHttpRequest();
    	} else {
        	var xhr = new ActiveXObject('Microsoft.XMLHTTP'); //IE6
    	}
    	
    	xhr.open("GET", "dhcst.getjsonbyclassmethod.csp?ClassName="+className+"&MethodName="+methodName+"&ParamStr="+argStr+"&ActionType=GetMethodWriteData", false);
    	xhr.send(null);
    	//alert(xhr.responseText);
    	//console.log(xhr.responseText);
    	return JSON.parse(xhr.responseText);
    	//return eval("("+xhr.responseText+")");
	}catch(e){
		alert(e);
		console.log(e);
	}
}

//@Huxiaotian 2018-07
//类方法使用Quit返回字符串, 不是使用Write
function jsRunClassMethod(className,methodName){
	try{
		var argStr = "";
		var parLen=jsRunClassMethod.arguments.length;
		for (var i=2; i<parLen; i++) {
			if(i==2){
				argStr = jsRunClassMethod.arguments[i];
			}else{
				argStr = argStr + "|@|" + jsRunClassMethod.arguments[i];
			}
		}
		if(parLen==2){
			argStr = "noparams";
		}
		if((argStr=="")&&(parLen==3)){
			argStr = "nullparam";
		}
		
		if (window.XMLHttpRequest) {
        	var xhr = new XMLHttpRequest();
    	} else {
        	var xhr = new ActiveXObject('Microsoft.XMLHTTP'); //IE6
    	}
    	
    	xhr.open("GET", "dhcst.getjsonbyclassmethod.csp?ClassName="+className+"&MethodName="+methodName+"&ParamStr="+argStr+"&ActionType=GetMethodQuitData", false);
    	xhr.send(null);
    	//alert(xhr.responseText);
    	//console.log(xhr.responseText);
    	//return JSON.parse(xhr.responseText);
    	//return eval("("+xhr.responseText+")");
    	return xhr.responseText;
	}catch(e){
		alert(e);
		console.log(e);
	}
}

//测试ajax
function testAjax(){
	ajax({
        url: "dhcst.dosometestaction.csp",  //请求地址
        type: "GET",                       //请求方式
        data: { actiontype: "test1", age: 20 },   //请求参数
        dataType: "json", //返回的数据类型
        success: function (response, xml) {
            // 此处放成功后执行的代码
            alert("成功："+response);
            console.log(response);
        },
        fail: function (status) {
            // 此处放失败后执行的代码
        }
    });
}

//原生js封装ajax
function ajax(options) {
	options = options || {};
    options.type = (options.type || "GET").toUpperCase();
    options.dataType = options.dataType || "json";
    options.async = options.async || true;
    var params = formatParams(options.data);

    //创建 - 第一步
    if (window.XMLHttpRequest) {
        var xhr = new XMLHttpRequest();
    } else {
        var xhr = new ActiveXObject('Microsoft.XMLHTTP'); //IE6及其以下版本浏览器
   	}
   	
	//接收 - 第三步
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4) {
            var status = xhr.status;
            if (status >= 200 && status < 300) {
	            if (options.dataType.toUpperCase() == "JSON"){
		            //var returnData = eval("("+xhr.responseText+")"); //返回json
	                var returnData = JSON.parse(xhr.responseText);
		        } else {
			        var returnData = xhr.responseText; //返回字符串
			    }
                options.success && options.success(returnData, xhr.responseXML);
            } else {
            	options.fail && options.fail(status);
            }
        }
    }

	//连接 和 发送 - 第二步
    if (options.type == "GET") {
        xhr.open("GET", options.url + "?" + params, options.async);
        xhr.send(null);
    } else if (options.type == "POST") {
        xhr.open("POST", options.url, options.async);
        //设置表单提交时的内容类型
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.send(params);
    }
}
    
//格式化参数
function formatParams(data) {
    var arr = [];
    for (var name in data) {
    	arr.push(encodeURIComponent(name) + "=" + encodeURIComponent(data[name]));
    }
    arr.push(("v=" + Math.random()).replace(".",""));
    return arr.join("&");
    /*
    var params = [];
	for (var key in opt.data){
		params.push(key + '=' + opt.data[key]);
	}
	return params.join('&');
	*/
}

//异步访问类方法 @Huxiaotian
function asyRunClassMethod(options) {
	options = options || {};
    //设置配置项默认值
	options.actionType = options.actionType || "GetMethodQuitData";
	options.requestType = (options.requestType || "GET").toUpperCase();
    options.returnType = options.returnType || "text";
    options.async = options.async || true;
    options.methodParams = options.methodParams || [];
	var className = options.className;
	var methodName = options.methodName;
	var methodParamsArr = options.methodParams;
	var methodParamsStr = "noparams";
	if (methodParamsArr.length==0) {
		methodParamsStr = "noparams";
	} else if ((methodParamsArr.length==1)&&(methodParamsArr[0]=="")){
		methodParamsStr = "nullparam";
	} else {
		methodParamsStr = methodParamsArr.join("|@|");
	}
    
	var requestParamStr = "ActionType=" + options.actionType + "&ClassName=" + className + "&MethodName=" + methodName + "&ParamStr=" + encodeURIComponent(methodParamsStr);
	var actionURL = "dhcst.getjsonbyclassmethod.csp";
	
	try{
		//创建 - 第一步
    	if (window.XMLHttpRequest) {
        	var xhr = new XMLHttpRequest();
    	} else {
        	var xhr = new ActiveXObject('Microsoft.XMLHTTP'); //IE6及其以下版本浏览器
   		}
   	
    	//接收 - 第三步
    	xhr.onreadystatechange = function () {
        	if (xhr.readyState == 4) {
            	var status = xhr.status;
            	if (status >= 200 && status < 300) {
                	if(options.returnType.toUpperCase()=="JSON"){
	                	var returnData = eval("("+xhr.responseText+")"); //返回json
	                	//var returnData = JSON.parse(xhr.responseText);
	            	}else{
		            	var returnData = xhr.responseText; //返回字符串
		        	}
                	options.success && options.success(returnData, xhr.responseXML);
            	} else {
            		options.fail && options.fail(status);
            	}
        	}
    	}
	 	
		//连接 和 发送 - 第二步
		if (options.requestType == "GET") {
        	xhr.open("GET", actionURL + "?" + requestParamStr, options.async);
        	xhr.send(null);
    	} else if (options.requestType == "POST") {
        	xhr.open("POST", actionURL, options.async);
        	xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded"); //设置表单提交时的内容类型
        	xhr.send(requestParamStr);
    	}
	}catch(err){
		alert(err);
		console.log(err);
	}
}

//var mask = myMask.createMask();
//myMask.showMask(mask);
//myMask.hideMask(mask);
var myMask = {
	createMask: function(msg){
		if(!msg){
			msg = "正在处理, 请稍后......"
		}
		var coverObj = document.getElementById("cover");
		if(coverObj){
			coverObj.style.cssText = "position: fixed;text-align:center;line-height:200px;top: 0;left: 0;height: 100%;width: 100%;background-color: rgba(0,0,0,0.3);display:none;z-index:1000;"
		}else{
			var coverObj = document.createElement("div");
			coverObj.id = "cover";
			var txtNode = document.createTextNode(msg);
			coverObj.appendChild(txtNode);
			coverObj.style.cssText = "position: fixed;text-align:center;line-height:200px;top: 0;left: 0;height: 100%;width: 100%;background-color: rgba(0,0,0,0.3);display:none;z-index:1000;"
			document.body.appendChild(coverObj); //这句话必须要
		}
		return coverObj;
	},
	showMask: function(coverObj){
		var h = document.documentElement.clientHeight || document.body.clientHeight;
		coverObj.style.lineHeight=Math.floor(h/2)+"px";
		coverObj.style.display='block';  //只需要改变属性
	},
	hideMask:function(coverObj){
		coverObj.style.display='none';
	}
}