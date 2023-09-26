/**
 * @ Huxiaotian 2018-04-30  GB2312����
 * @ �ṩ����: �ļ����������ȡ
 *  downloadFiles(url) //���ط������ļ�
 *  readLocalFiles(callBackFn,suffix) //�����ļ���,��ȡ�����ļ�
 *	loadScript("xlsx_full_min_js","../scripts/filehandingutiljs/xlsx.full.min.js",function(){}) //��̬����js�ļ�
 *  -----export excel----
 *	downloadExcelSimple(jsonResult,needTitle) //ie�����µ����򵥵�Excel�ļ�
 *	downloadExcel(data, title, fileName) //ʹ��xlsx.full.min.js����Excel, Ч�ʸ�
 *  exportDataToExcel({servercsp:'',postdata:{},title:{}}) //exportJsonToExcel�����������Ż�(******)
 *  exportJsonToExcel(data,title,fileName) //����ie������������ĵ�������, ���������κβ��
 *  -----read excel-----
 *	jsReadFiles(function(result){//do something here with result}) //��ȡ�����ı��ļ���ͼƬ�ļ�
 *	jsReadExcelAsJson(function(result){//do something here with result}) //��ȡExcel�ļ�����Ϊjson����
 *	readLocalExcel() //��ȡ���ص�Excel�ļ�����json����
 *  -----xml------
 *	loadXML(xmlFileUrl) //�ѷ�������xml���ص�js��, ���ص���xml����
 *	jsReadLocalXML(function(result){//do something here with result}) //��ȡ���ص�xml�ļ���Ϊ�ַ���, �ٰ��ַ���ת��Ϊxml����
 *	xmlStrToXmlObj(str) //xml�ַ���ת��Ϊxml�ĵ�����
 *  -----ajax------
 *	getJsonByClassMethod(className,methodName) //��̨�෽��w�����json�ַ���ת��Ϊjson����
 *  jsRunClassMethod(className,methodName) //js�л�ȡ�෽���ķ���ֵ
 *  asyRunClassMethod({}) //�첽�����෽��
 *	ajax(options) //ԭ��js��װajax, ����������п���ʹ��
 * @ Others: 
 */
//-------------------------------------------------------------------------------------------
//�ļ����ط���
//url : ../Results/Template/longObjectFile.xls
function downloadFiles(url){
	var a = document.createElement("a");
	a.setAttribute("download","");
	a.setAttribute("href",url);
	document.body.appendChild(a);
	a.click(); //ģ����
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

//���ʵ���ļ����ϴ�?????????????????????????
function uploadFiles(url) {
	/* FormData �Ǳ������� */
	var fd = new FormData();
	var ajax = new XMLHttpRequest();
	fd.append("upload", 1);
	/* ���ļ���ӵ����� */
	fd.append("upfile", document.getElementById("fb").files[0]);
 	ajax.open("post", url, true); 
 	ajax.onload = function () {
 		console.log(ajax.responseText);
 	};
 	ajax.send(fd);
 	console.log(fd);
}

//Desc: �����ļ���,��ȡ�����ļ�
//Input: callBackFn - �ص�����, ����û�ѡ����ļ���Ϊ�������ݸ��ص�����
function readLocalFiles(callBackFn,suffix){
	//��̬�����ļ������(����Ҫ��ҳ�����ٵ�����һ��input)
	var inputFileBox = document.createElement("input");
	inputFileBox.type="file";
	inputFileBox.onchange=function(){
		//jsReadFiles(this.files); /*��ȡ�ı��ļ���ͼƬ�ļ�*/
		//jsReadExcelAsJson(this.files); /*��ȡExcel�ļ�*/
		//jsReadLocalXML(this.files); /*���ı���ȡxml*/
		var files = this.files;
		if((suffix)&&(files[0].name.indexOf(suffix)<=0)){
			alert("�ļ���ʽ����,��ѡ���׺Ϊ: "+suffix+" ���ļ�!");
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

//����Ҫ��ʱ��, ��̬����js�ļ�
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
 * @ Excel�������� (һ) ------------------------
 */
// Huxiaotian 2018-04
// Desc: �ѴӺ�̨��ȡ��json������ΪExcel�ĵ�, ��֧��IE����Ҫ��װExcel
// Input: jsonResult - json����(�����ַ���), ��:[{"name":"Huxiaotian","age":25},{"name":"Huxiaotian2","age":26}]
//        needTitle - json����Ҫ�����е�key ��ɵ�����(���û�д���,Ĭ��ȫ����), ��: {"name":"����","age":"����"}
// Output: Excel
// Others: �÷���ʹ�������ݱȽ��ٵ�(��༸����),������ݽ϶����׿���
function downloadExcelSimple(jsonResult,needTitle) {
	if(jsonResult.length<1){
		alert("û������, �޷�����!");
		return;
	}
	var need_title = null;
	for (var i=1; i<downloadExcelSimple.arguments.length; i++) {
		need_title = downloadExcelSimple.arguments[i];
	}
	try{
		//����ģ��
		var oXL = new ActiveXObject("Excel.Application"); 
		var oWB = oXL.Workbooks.Add(); 
		var oSheet = oWB.ActiveSheet;
		if (need_title) {
			//���ñ���
			var k=0;
			for (var t in need_title){
				oSheet.Cells(1,k+1).value = need_title[t];
				k=k+1;
			}
			//��д����
			var rows = jsonResult.length; //����
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
			//���ñ���
			var k=0;
			for (var title in jsonResult[0]){
				oSheet.Cells(1,k+1).value = title;
				k=k+1;
			}
			//��д����
			var rows = jsonResult.length; //����
			for (var i=0;i<rows;i++){
				var j=0;
				for (var key in jsonResult[i]){
					oSheet.Cells(i+2,j+1).value = jsonResult[i][key];
					j=j+1;
				}
			}
		
		}
		//����--->1
		//oXL.Visible = true; 
		//oXL.UserControl = true;
		//����--->2
        var fname = oXL.Application.GetSaveAsFilename("Excel.xls", "Excel Spreadsheets (*.xls), *.xls");
	}catch(e){
		alert(e+"\n"+"��ʹ��IE�����,��װOffice2003�����ϰ汾,���������������Active�ؼ�!");
		console.log(e+"\n"+"��ʹ��IE�����,��װOffice2003�����ϰ汾,���������������Active�ؼ�!");
		print("Nested catch caught " + e);
	}finally{
		//xls.Visible = false;
		oWB.SaveAs(fname);
		oWB.Close(savechanges = false);
        oXL.Quit();
        oXL = null;
	}
}

//json����ı�������
function testSomething(){
	var json = [{"dd":'SB',"AA":'����',"re1":123},{"cccc":'dd',"lk":'1qw'}];
	for(var i=0,l=json.length;i<l;i++){
		for(var key in json[i]){
			console.log(key);
��������	//console.log(key+':'+json[i][key]);
����	}
	}
}

// Add By Huxiaotian 2018-04
// Desc: Json������ΪExcel�ļ�, ie google����֧��
// Input: data - json����
//        title - json����Ҫ�������м������ĺ���, ��:{"name":"����","age":"����"}, �����Ҫ�������������� - null
//        fileName - �ļ���, ��: xxxxxx.xlsx
//        sheetName - ͬһ��Excel�ļ��е�sheet��, ��: sheet1
// Output: Excel
// Others: �Ż�: ԭ������IE��֧��Object.assign()��¡�ͺϲ�����,ע�͵���Object.assign()����Ĳ���
//         �÷�����Ҫ�����ⲿjs�ļ�FileSaver.min.js��xlsx.full.min.js, �����ļ���Ч�ʸ�
function downloadExcel(data, title, fileName) {
	//1. ����js������ɺ���õĺ���
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
			// ��json��ʽ������תΪexcel��������ʽ
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

			//��������,�������A1��D10,SheetNames:����
			var coordinate = Object.keys(content);
			var CellsZone = {"!ref":coordinate[0] + ":" + coordinate[coordinate.length - 1]};
			var workBook = {
				SheetNames: ["Sheet1"],
				Sheets: {
					"Sheet1" : extend(content,CellsZone) //Object.assign({}, content, { "!ref": coordinate[0] + ":" + coordinate[coordinate.length - 1] })
				}
			};
			//console.log(workBook);
			
			//������������������嵼���ĸ�ʽ����
			var excelData = XLSX.write(workBook, { bookType: "xlsx", bookSST: false, type: "binary" });
			var blob = new Blob([string2ArrayBuffer(excelData)], { type: "" });
			saveAs(blob, fileName); // scripts/filehandingutiljs/FileSaver.min.js
		}catch(e){
			alert(e);
		}
	}
	
	//2. ��̬����js:xlsx.full.min.js
	var jsId = "xlsx_full_min_js";
	var jsUrl = "../scripts/filehandingutiljs/xlsx.full.min.js";
	var doLoadjs = (function(){
		loadScript(jsId,jsUrl,doLoadExcel);
	})()
}

//�ַ���ת�ַ���
function string2ArrayBuffer(s) {
	var buf = new ArrayBuffer(s.length);
	var view = new Uint8Array(buf);
	for (var i = 0; i != s.length; ++i) view[i] = s.charCodeAt(i) & 0xFF;
	return buf;
}

// ��ָ������Ȼ��ת��Ϊ26���Ʊ�ʾ��ӳ���ϵ��[0-25] -> [A-Z]��
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

//�ϲ�����,ԭ������IE��֧��Object.assign()�����ϲ�����
function extend(target, source) {
	for (var obj in source) {
    	target[obj] = source[obj];
    }
    return target;
}

/* 
 * @ Excel�������� (��) ------------------------
 * Huxiaotian 2018-05
 */
// Huxiaotian 2018-05-07
// ����Excel�ļ�,�򻯷���:
// ֻ��Ҫ����url, �������, ��Ҫ������title; ���������url���뷵��json�ַ���
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
	opt.filename = opt.filename || "�����ļ�.xls";
	
	var fileName;
	if(browserIsIE()){
		fileName = getFileName(); //IE�����ʹ��Active�ؼ������ļ���
	}else{
		fileName = opt.filename; //��IE������ļ�����,�û��������Ĭ���ļ���
	}
	
	ajax({
        url: opt.servercsp,   //�����ַ
        type: "GET",          //����ʽ
        data: opt.postdata,   //�������
        dataType: "json",     //���ص���������
        success: function (response, xml) {
            try{
	            var ret = JSON.parse(response);
	        }catch(e){
		        alert(e+"\n"+"JSON����ת��ʧ��! �������ݸ�ʽ��������Ƿ�֧��JSON.parse()����");
		        return;
		    }
		    //console.log(ret);
            exportJsonToExcel(ret, opt.title, fileName);
            alert("����Excel�ɹ�!");
        },
        fail: function (status) {
            // �˴���ʧ�ܺ�ִ�еĴ���
            alert("����ʧ��!");
        }
    });
    
    return;
}

//����ie������������ĵ�������
//Input: data - ʹ���첽���ػ�ȡ����
//       title - ��js������
//       fileName - �ڻ�ȡdata֮ǰʹ��getFileName()��ȡ, ��Ҫ��ע��MSCommonDialog.reg
//Others: 
function exportJsonToExcel(data,title,fileName){
	if(browserIsIE()){
		ExportForIE(data,title,fileName); //ie��������active, ��д�ļ�
	} else {
		ExportForOthers(data,title,fileName); //�����֧��dataЭ��, ie��֧��
	}
}

//IE�������������, ��д�����ļ�
//data: [{},{},{}]
//title: {}
//fileName: "C:\\Users\\Administrator\\Desktop\\���ǲ����ļ�.xls"
//ExportForIE(data,title,"C:\\Users\\Administrator\\Desktop\\���ǲ����ļ�.xls")
function ExportForIE(data,title,fileName){
	if(!fileName){
		fileName = getFileName();
	}
	try{
		var fso = new ActiveXObject("Scripting.FileSystemObject");
		var sTextfile = fso.CreateTextFile(fileName,true,true);
		
		//Excel��һ�д�ű���
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
		
		//�ڶ��п�ʼ������
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

//�����������������,�÷�����֧��IE����Excel
function ExportForOthers(data,title,fileName){
	var table=getHtmlTableStr(data,title);
	/*����url*/
	var uri = 'data:application/vnd.ms-excel;base64,',
	/*����html�ַ���*/
    template = '<html><head><meta charset="UTF-8"></head><body>'+table+'</body></html>',
	/*����base64������*/
    base64 = function(s) { return window.btoa(unescape(encodeURIComponent(s))) }
	/*���غ���:�Ե���*/
    return (function() {
    	window.location = uri + base64(template); //�������url�ĳ���������,���url�����������޷�����
    	//window.location.href = uri + base64(template);
    	/*
    	var a = document.createElement("a");
		a.setAttribute("download",fileName); //���ַ�������ָ�������ļ�������,������ָ������·��
		a.setAttribute("href",uri + base64(template));
		document.body.appendChild(a);
		a.click(); //ģ����
		a.parentNode.removeChild(a);
		*/
    })()
}

//ʹ������ƴ��html��table��ǩ�ַ���
//����ͨ�����ñ�ǩ������������Excel���ĸ�ʽ
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
			//ֻ����Ҫ����
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

//�ж��Ƿ���IE,��IE֧��ActiveXObject
function browserIsIE() {   
    if (!!window.ActiveXObject || "ActiveXObject" in window) { 
    	return true;
    } else {
	    return false;
	}
}

//�û��ڵ�����ѡ���ļ��ı���·���������ļ�������
//������: C:\Users\Administrator\Desktop\1111.xls
function getFileName(){
	var fileName="";
	try {	
		var mscd = new ActiveXObject("MSComDlg.CommonDialog");
		mscd.Filter = "Microsoft Office Excel(*.xls)|*.xls";
		mscd.FilterIndex = 1;
		// ��������MaxFileSize. �������
		mscd.MaxFileSize = 32767;
		// ��ʾ�Ի���
		mscd.ShowSave();
		fileName=mscd.FileName;
		mscd=null;
	} catch(e) {
		if (confirm("��ǰϵͳ��֧�ִ���·��,�Ƿ������ļ�����?\n����ɹ���,�����������Ч!")){
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

//�÷���ֻ�����ļ������·��
//������: C:\Users\Administrator\Desktop
function getFilePath() {
	try {
		var shell = new ActiveXObject("Shell.Application");
		//var folder = shell.BrowseForFolder(0, '��ѡ��洢Ŀ¼', 0x0040, 0x11); //��ʼλ��: �ҵĵ���
		var folder = shell.BrowseForFolder(0, '��ѡ��洢Ŀ¼', 0); //��ʼλ��: ����
		var filePath;
		if (folder != null) {
			if (folder == "����") {
				var shell_2 = new ActiveXObject('WScript.Shell');
				filePath = shell_2.ExpandEnvironmentStrings('%UserProfile%\\Desktop');
				//filePath = "C:\\Users\\Administrator\\Desktop"; //����·��
			} else {
				filePath = folder.Items().Item().Path;
			}   
		}
		return filePath;
	}catch (e) {
		//alert("��ѡ��������ļ��к��ٽ�������");
		alert(e.message);
	}
}

/* -------------------------------------------------------------------------------------
 * FileReader����4�ֶ�ȡ������(html5 - ֻ֧��ie8�����ϰ汾)
 * 1.readAsArrayBuffer(file)�����ļ���ȡΪArrayBuffer��
 * 2.readAsBinaryString(file)�����ļ���ȡΪ�������ַ���(ie��֧��)
 * 3.readAsDataURL(file)�����ļ���ȡΪData URL
 * 4.readAsText(file, [encoding])�����ļ���ȡΪ�ı���encodingȱʡֵΪ'UTF-8'
 */
//��ȡ�ı��ļ���ͼƬ�ļ�
function jsReadFiles(callbackFn){
	//ѡ���ļ���, ִ�ж�ȡ������������
	var doReadFile = function(files){
		if (files.length) {
			var file = files[0];
			var reader = new FileReader();/*FileReaderʵ��, ��ie8�������ϵİ汾��֧��*/
			if (/text+/.test(file.type)) {
				reader.onload = function() {
					//alert(this.result);
					//return this.result; //�첽ִ�з�����Ч,ʹ�ûص�����
					if(callbackFn){
						callbackFn(this.result);
					}
				}
				reader.readAsText(file,'gb2312'); /*��ȡ�ı��ļ�*/
				//reader.readAsText(file,'utf-8');
			} else if(/image+/.test(file.type)) {
				reader.onload = function() {
					$('body').append('<img src="' + this.result + '"/>');
				}
				reader.readAsDataURL(file); /*��ȡͼƬ�ļ�*/
			}
		}
	}
	
	//ִ�ж�ȡ
	readLocalFiles(doReadFile);
}

//------------------>
//��Excel�ļ�����Ϊjson����, ie/google����
//������: filehandingutiljs/xlsx.full.min.js, ���ǵ�Ч������,�Ҿ���ʹ��js��̬���صķ�ʽ,����Ҫ��ʱ�����,�����Ͳ�Ӱ��ԭ��ҳ�ĳ�ʼ��Ч��
//ʹ���ڲ�����(�հ�),����ֱ�ӷ�������㺯���Ĳ���
function jsReadExcelAsJson(callFn){
	//1. ��ȡǰ ��̬����js:xlsx.full.min.js
	var jsId = "xlsx_full_min_js";
	var jsUrl = "../scripts/filehandingutiljs/xlsx.full.min.js";
	loadScript(jsId, jsUrl, function(){
		//readLocalFiles(doReadExcel); //�����ļ���,��ȡ�ļ�,�첽���غ�click�¼���ʧЧ
	});
	
	//2. ִ�ж�ȡ������������
	var doReadExcel = function (files){
		var wb; //��ȡ��ɵ�����
		var rABS = true; //�Ƿ��ļ���ȡΪ�������ַ���
		if(!files) {
			alert("��ѡ���ļ�!");
			return;
		}
		var f = files[0];
		var reader = new FileReader(); //ie8 google
		//��ȡ��ɺ�ִ�� ----->
		reader.onload = function(e) {
			var xlsx = document.getElementById("xlsx_full_min_js");
			if(!xlsx){
				alert("����jsδ�������,���Ժ�����!");
				return;
			}
			var data = e.target.result;
			if(rABS) {
				wb = XLSX.read(btoa(fixdata(data)), {//�ֶ�ת��
					type: 'base64'
				});
			} else {
				wb = XLSX.read(data, {
					type: 'binary'
				});
			}
			//wb.SheetNames[0]�ǻ�ȡSheets�е�һ��Sheet������
			//wb.Sheets[Sheet��]��ȡ��һ��Sheet������
			//var jsonStr = JSON.stringify( XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]]) ); //����ת��Ϊ�ַ���
			var jsonObj = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]]);
			//console.log(jsonObj);
			//alert(jsonObj);
			//return jsonObj; /*�������첽��ȡ��, �޷�ֱ��ʹ�÷���ֵ, ֻ��ʹ�ûص�����*/
			if(callFn){
				callFn(jsonObj);
			}
		};
		
		//ִ�ж�ȡ�ļ����� ----->
		if(rABS) {
			reader.readAsArrayBuffer(f);
		} else {
			reader.readAsBinaryString(f);
		}
	}
	
	//3. ��̬�����ļ��ļ���,�����ļ����ݸ��ص�����
	readLocalFiles(doReadExcel,".xls");
	return;
}

//�ļ���תBinaryString
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
		alert("warning","���밲װexcel��ͬʱ���������ִ��ActiveX�ؼ�");
		return false;
	}
	try{
		var xlsBook = xlsApp.Workbooks.Open(fileName);
		var xlsSheet = xlsBook.Worksheets(1);		//ps: ʹ�õ�һ��sheet
		var ret = ReadDataAsJson(xlsApp, xlsBook, xlsSheet); //��ȡһ��
	}catch(e){
		alert(e);
		alert('error', '��ȡExcelʧ��:' + e);
	}
	xlsApp.Quit();
	xlsApp = null;
	xlsBook = null;
	xlsSheet = null;
	return ret;	//����Excel����,��������
	return;
}
function ReadDataAsJson(xlsApp, xlsBook, xlsSheet){
	var rowsLen = xlsSheet.UsedRange.Rows.Count;
	var colsLen = xlsSheet.UsedRange.Columns.Count;
	var arr = [];
	var StartRow = 1; //��2�п�ʼ
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
//Desc: ����������xml�ĵ����ڴ���, ������Ϊxml�ĵ�����
//Date: 2018-04-29
//Input: xmlFileUrl - ��������xml�ļ���·��λ��
//Output: xml�ĵ�����(������html����)
function loadXML(xmlFileUrl) {
	var xmlDoc;
	if (window.ActiveXObject) {
		//alert("ie"); //IE�����(Ϊʲô�ҵ�ie����????)
	    var xmlDomVersions = ['Microsoft.XMLDOM','MSXML.2.DOMDocument.6.0','MSXML2.DOMDocument.4.0','MSXML.2.DOMDocument.3.0'];  
        for(var i=0;i<xmlDomVersions.length;i++){  
            try{  
                xmlDoc = new ActiveXObject(xmlDomVersions[i]); //�жϵ�ǰ�����֧��ʲô�汾
                break;  
            }catch(err){  
            }
        }
		xmlDoc.async = false;
		xmlDoc.load(xmlFileUrl);
	} else if (isFirefox=navigator.userAgent.indexOf("Firefox")>0) { 
		//alert("firefox"); //��������
		//else if (document.implementation && document.implementation.createDocument) {}
		xmlDoc = document.implementation.createDocument('', '', null);
		xmlDoc.load(xmlFileUrl);
	} else {
		//alert("google"); //google�����
		var xmlhttp = new window.XMLHttpRequest();
		xmlhttp.open("GET",xmlFileUrl,false);
		xmlhttp.send(null);
		if(xmlhttp.readyState == 4){
			xmlDoc = xmlhttp.responseXML; //֧��ie11��google
		} 
	}
	if (xmlDoc == null) {
		alert('�����������֧��xml�ļ���ȡ,���Ǳ�ҳ���ֹ���Ĳ���,�Ƽ�ʹ��IE5.0���Ͽ��Խ��������!');
		window.location.href = '../err.html';
	}
	//xmlDoc.documentElement ---> xml�ĵ��ĸ��ڵ�
	console.log(xmlDoc);
	return xmlDoc; 
}

//Desc: js��ȡ���ص�xml�ļ�,����xml������Ϊ�������ݸ��ص�����callBackFn, �ڻص������п��Խ���xml�ĵ����������
//Input: callBackFn - �ص�����,�ص�����ֻ���Զ�xml�ĵ�������в���
//Output: 
function jsReadLocalXML(callBackFn){
	var inputFileBox = document.createElement("input");
	inputFileBox.type="file";
	inputFileBox.onchange=function(){
		//----------------------------
		var files=this.files;
		var file = files[0];
		var reader = new FileReader(); /*��ie8�������ϵİ汾��֧��*/
    	reader.onload = function() {
	    	//alert(this.result);
	    	var xmlDocObj = xmlStrToXmlObj(this.result); //���ý����ַ����ķ���
	    	console.log(xmlDocObj.documentElement);
	    	if(callBackFn){
		    	callBackFn(xmlDocObj);
			}
    	}
    	//reader.readAsText(file,'gb2312'); /*��ȡ�ı��ļ�*/
    	reader.readAsText(file,'utf-8');
    	//----------------------------
	}
	document.body.appendChild(inputFileBox);
	inputFileBox.click();
}

//Desc: js����xml�ַ���Ϊ����,ie11���²�֧��
//Input: xml�ַ���
//Output: xml�ĵ�����
function xmlStrToXmlObj(str){
    var allowIE = false; //�Ƿ�����ie, ��ʱд��
    try{
	    if((browserIsIE()==true)&&(allowIE==true)){
	    	alert("ie");
	    	var xmlDoc;
	    	var xmlDomVersions = ['Microsoft.XMLDOM','MSXML.2.DOMDocument.6.0','MSXML2.DOMDocument.4.0','MSXML.2.DOMDocument.3.0'];  
        	for(var i=0;i<xmlDomVersions.length;i++){  
            	try{  
                	xmlDoc = new ActiveXObject(xmlDomVersions[i]); //�жϵ�ǰ�����֧��ʲô�汾
                	break;  
            	}catch(err){  
            	}
        	}
	    	xmlDoc.loadXML(str); //����: xmlDoc.load(url); xmlDoc.loadXML(str)
	    	return xmlDoc;
		}else{
			alert("g");
			var parser=new DOMParser();
    		var xmlDoc=parser.parseFromString(str,"text/xml");
    		return xmlDoc;
		}
	} catch (e) {
		alert(e+":"+"��ʹ��IE11��ȸ������")
	}
}

//���� ��ȡxml�ĵ������е�ֵ
//xmlDoc : xml�ĵ�����(�����ڼ��ص��ڴ��е�html��ǩ)
function testXmlRead(xmlDoc){
	//��ȡ����  
    var banks = xmlDoc.getElementsByTagName('bank');
    for (var i = 0; i < banks.length; i++) {  
        //console.log(banks[i].textContent);  
        if(banks[i].attributes["bankName"]){
	        console.log(banks[i].attributes["bankName"].value);
	    }
    }
}

//js����xml�ļ������أ�ie & google --> �ڷ�������ʹ��M����xml,��ʹ���ļ����صķ�ʽ���ص�����

//---------------------------------------------------------------------


/*
 * Huxiaotian 2018-04
 * Desc: ��ȡ��̨����, ������tkMakeServerCall()
 *       �����෽���в�����-q����ֵ-����ʹ��-w����ֵ-��ʱ��,ʹ�ø÷���
 * Input: 
 *     className - ����,
 *     methodName - ������,
 *     ���� - �����б�(�����ĸ���������ClassMethod�Ĳ�������һ��,�������׳���)
 * Output: Json����,�����ַ���
 * Others: �����·����: dthealth/web/csp/dhcst.getjsonbyclassmethod.csp (ʹ��ǰ���������csp,����÷�����Ч)
 *         �÷�����tkMakeServerCall()һ��, ��ͬ�����ص�, ���÷���ִ����ɺ����ִ�к���Ĵ���
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
//�෽��ʹ��Quit�����ַ���, ����ʹ��Write
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

//����ajax
function testAjax(){
	ajax({
        url: "dhcst.dosometestaction.csp",  //�����ַ
        type: "GET",                       //����ʽ
        data: { actiontype: "test1", age: 20 },   //�������
        dataType: "json", //���ص���������
        success: function (response, xml) {
            // �˴��ųɹ���ִ�еĴ���
            alert("�ɹ���"+response);
            console.log(response);
        },
        fail: function (status) {
            // �˴���ʧ�ܺ�ִ�еĴ���
        }
    });
}

//ԭ��js��װajax
function ajax(options) {
	options = options || {};
    options.type = (options.type || "GET").toUpperCase();
    options.dataType = options.dataType || "json";
    options.async = options.async || true;
    var params = formatParams(options.data);

    //���� - ��һ��
    if (window.XMLHttpRequest) {
        var xhr = new XMLHttpRequest();
    } else {
        var xhr = new ActiveXObject('Microsoft.XMLHTTP'); //IE6�������°汾�����
   	}
   	
	//���� - ������
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4) {
            var status = xhr.status;
            if (status >= 200 && status < 300) {
	            if (options.dataType.toUpperCase() == "JSON"){
		            //var returnData = eval("("+xhr.responseText+")"); //����json
	                var returnData = JSON.parse(xhr.responseText);
		        } else {
			        var returnData = xhr.responseText; //�����ַ���
			    }
                options.success && options.success(returnData, xhr.responseXML);
            } else {
            	options.fail && options.fail(status);
            }
        }
    }

	//���� �� ���� - �ڶ���
    if (options.type == "GET") {
        xhr.open("GET", options.url + "?" + params, options.async);
        xhr.send(null);
    } else if (options.type == "POST") {
        xhr.open("POST", options.url, options.async);
        //���ñ��ύʱ����������
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.send(params);
    }
}
    
//��ʽ������
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

//�첽�����෽�� @Huxiaotian
function asyRunClassMethod(options) {
	options = options || {};
    //����������Ĭ��ֵ
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
		//���� - ��һ��
    	if (window.XMLHttpRequest) {
        	var xhr = new XMLHttpRequest();
    	} else {
        	var xhr = new ActiveXObject('Microsoft.XMLHTTP'); //IE6�������°汾�����
   		}
   	
    	//���� - ������
    	xhr.onreadystatechange = function () {
        	if (xhr.readyState == 4) {
            	var status = xhr.status;
            	if (status >= 200 && status < 300) {
                	if(options.returnType.toUpperCase()=="JSON"){
	                	var returnData = eval("("+xhr.responseText+")"); //����json
	                	//var returnData = JSON.parse(xhr.responseText);
	            	}else{
		            	var returnData = xhr.responseText; //�����ַ���
		        	}
                	options.success && options.success(returnData, xhr.responseXML);
            	} else {
            		options.fail && options.fail(status);
            	}
        	}
    	}
	 	
		//���� �� ���� - �ڶ���
		if (options.requestType == "GET") {
        	xhr.open("GET", actionURL + "?" + requestParamStr, options.async);
        	xhr.send(null);
    	} else if (options.requestType == "POST") {
        	xhr.open("POST", actionURL, options.async);
        	xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded"); //���ñ��ύʱ����������
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
			msg = "���ڴ���, ���Ժ�......"
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
			document.body.appendChild(coverObj); //��仰����Ҫ
		}
		return coverObj;
	},
	showMask: function(coverObj){
		var h = document.documentElement.clientHeight || document.body.clientHeight;
		coverObj.style.lineHeight=Math.floor(h/2)+"px";
		coverObj.style.display='block';  //ֻ��Ҫ�ı�����
	},
	hideMask:function(coverObj){
		coverObj.style.display='none';
	}
}