// creator by lhh
(function() {
	Ext.ns("dhcwl.complexrpt");
	// 工具函数供导入script文件用
	dhcwl.complexrpt.Util = function() {
	};
	dhcwl.complexrpt.Util.importScript = function(file) {
		if (!file || file == "")
			return;
		var scriptLink = document.getElementsByTagName("script");
		for (var i = 0; i < scriptLink.length; i++) {
			if (scriptLink[i].getAttribute("src")
					&& scriptLink[i].getAttribute("src") == file)
				return;
		}
		var new_element;
		var head = document.getElementsByTagName("head");
		new_element = document.createElement("script");
		new_element.setAttribute("type", "text/javascript");
		new_element.setAttribute("src", file);
		void(head[0].appendChild(new_element));
	}

	// 工具函数供导入CSS文件用
	dhcwl.complexrpt.Util.importCSS = function(file) {
		if (!file || file == "")
			return;
		var scriptLink = document.getElementsByTagName("link");
		for (var i = 0; i < scriptLink.length; i++) {
			if (scriptLink[i].getAttribute("src")
					&& scriptLink[i].getAttribute("src") == file)
				return;
		}
		var new_element;
		var head = document.getElementsByTagName("head");
		new_element = document.createElement("link");
		new_element.setAttribute("type", "text/css");
		new_element.setAttribute("rel", "stylesheet");
		new_element.setAttribute("href", file);
		void(head[0].appendChild(new_element));
	}

	//判断给定字符串是否只为字母或数字的组合
	dhcwl.complexrpt.Util.valideValue=function(code){
		if (code==null||code=="") return '不允许为空';
		var c='';
		for(var i=code.length-1;i>-1;i--){
			c=code.charAt(i);
			if((c>='a'&&c<='z')||(c>='A'&&c<='Z')||(c>='0')&&(c<='9'))
				continue
			else
				return '只能为字母或数字的组合';
		}
		return true;
	}

	//返回给定年的每月天数
	dhcwl.complexrpt.Util.getMonthDays=function(year,month){
		var days=[31,28,31,30,31,30,31,31,30,31,31,30,31];
		if(month==1){
			if(((year%4==0)&&(year%100!=0))||(year%400==0)){
				return 29;
			}else{
				return 28;
			}
		}
		return days[month];
	}
	// 返回当前日期的字符串格式为yyyy-mm-dd
	dhcwl.complexrpt.Util.nowDate = function() {
		var date = new Date();
		date = (date.getFullYear())
				+ '-'
				+ ((date.getMonth() < 9)
						? ('0' + (date.getMonth() + 1))
						: (date.getMonth() + 1))
				+ '-'
				+ (date.getDate() < 10 ? ('0' + date.getDate()) : date
						.getDate());
		return date;
	}
	dhcwl.complexrpt.Util.yesterday = function() {
		var date = new Date();
		var year=date.getFullYear(),month=date.getMonth(),day=date.getDate();
		if(day==1){
			if(month==0){
				month=12;
				year--;
			}else{
				month--;
			}
			day=dhcwl.complexrpt.Util.getMonthDays(year,month);
		}else{
			day--;
		}
		date = (year)
				+ '-'
				+ ((month < 9)
						? ('0' + (month + 1))
						: (month + 1))+ '-'
				+ (day < 10 ? ('0' + day) : day);
		return date;
	}
	// 返回当前日期和时间的字符串格式为yyyy-mm-dd hhmmss
	dhcwl.complexrpt.Util.nowDateTime = function() {
		var date = new Date();
		date = (date.getFullYear())
				+ '-'
				+ ((date.getMonth() < 9)
						? ('0' + (date.getMonth() + 1))
						: (date.getMonth() + 1))
				+ '-'
				+ (date.getDate() < 10 ? ('0' + date.getDate()) : date
						.getDate()) + " " + date.getHours() + date.getMinutes()
				+ date.getSeconds();//+" "+date.getMilliseconds();
		return date
	}
	// ajax操作工具方法
	dhcwl.complexrpt.Util.ajaxExc = function(url, para, successFun, successScope,onlyText,timeout) {
		if (!para)
			para = {};
		if (!successFun)
			successFun = null;
		if (!successScope)
			successScope = this;
		if(!onlyText)
			onlyText=false;
		if(!timeout)
			timeout=null;
		Ext.Ajax.request({
					url : encodeURI(url),
					waitMsg : '正在处理...',
					failure : function(result, request) {
						Ext.Msg.show({
									title : '网络连接失败！',
									msg : '请检查网络连接!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
					},
					success : function(result, request) {
						if(onlyText){
							if (successFun != null) {
								if (successScope != null)
									successFun.call(successScope, result.responseText);
								return;
							}
						}
						if (!result.responseText) {
							Ext.Msg.show({
										title : '处理成功！',
										msg : "无响应数据!",
										icon : Ext.MessageBox.INFO,
										buttons : Ext.Msg.OK
									});
						}
						var jsonData, tip;
						try {
							jsonData = Ext.util.JSON.decode(result.responseText);
							tip = jsonData.tip;
						} catch (e) {
							Ext.Msg.show({
										title : '错误',
										msg : "处理响应数据失败！响应数据为：\n"
												+ (result.responseText),
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
							return;
						}
						if (successFun != null) {
							if (successScope != null)
								successFun.call(successScope, jsonData);
								return;
						}
						if (jsonData.success == true) {
							if (tip == "ok") {
								Ext.Msg.show({
											title : '处理成功！',
											msg : "操作成功!",
											icon : Ext.MessageBox.INFO,
											buttons : Ext.Msg.OK
										});
							} else {
								Ext.Msg.show({
											title : '错误',
											msg : tip,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							}
						} else {
							Ext.Msg.show({
										title : '错误',
										msg : "业务操作失败！\n" + tip,
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						}
					},
					scope : this,
					params : para,
					timeout:timeout||60000
				});
	}
	// JS处理本地文件方法
	//浏览本地文件系统目录
	dhcwl.complexrpt.Util.browseFolder = function() {
		var FilePath = "";
		var objSrc = new ActiveXObject("Shell.Application").BrowseForFolder(0,
				"请选择路径", 0, "");
		if (objSrc != null) {
			if (objSrc.Self.IsFileSystem) {
				FilePath = objSrc.Self.Path;
			} else {
				alert('请选择正确路径!');
			}
		}
		return FilePath;
	}
	//根据文件路径打开文件
	dhcwl.complexrpt.Util.openFile = function openFile(filePath) {
		var fso, f;
		fso = new ActiveXObject("Scripting.FileSystemObject");
		if (fso.FileExists(filePath)) {
			f = fso.OpenTextFile(filePath, 1, false);
		} else {
			f = null;
		}
		return f;
	}
	//写内容到指定文件名中
	dhcwl.complexrpt.Util.writeFile = function(filename, filecontent) {
		var fso, f, s;
		fso = new ActiveXObject("Scripting.FileSystemObject");
		var dir = dhcwl.complexrpt.Util.browseFolder();
		f = fso.OpenTextFile(dir + "\\" + filename, 8, true);
		f.WriteLine(filecontent);
		f.Close();
	}
	dhcwl.complexrpt.Util.browseFile = function(folderPath) {
		var FilePath = "";
		var folder = new ActiveXObject("Shell.Application").BrowseForFolder(0,
				"请选择XML文件",0x2000|0x4000,"");
		
		
		return folder.Path;
	}
	// 从已打开文件中读取指定字节数的内容
	dhcwl.complexrpt.Util.stepReadFile = function(file, stepSize) {
		if (!file)
			return "";
		var content = "", vs = "";
		for (var i = 0; i < stepSize; i++) {
			try {
				vs = file.Read(1);
			} catch (ex) {
				return content;
			}
			if (!vs)
				break;
			content += vs;
		}
		return content;
	}
	dhcwl.complexrpt.Util.trimLeft = function(s) {
		if (s == null) {
			return "";
		}
		var whitespace = new String(" \t\n\r	");
		var str = new String(s);
		if (whitespace.indexOf(str.charAt(0)) != -1) {
			var j = 0, i = str.length;
			while (j < i && whitespace.indexOf(str.charAt(j)) != -1) {
				j++;
			}
			str = str.substring(j, i);
		}
		return str;
	}
	
	function read(file) {
		var fso;
	    if(typeof window.ActiveXObject != 'undefined') {
	        try {
	            fso = new ActiveXObject("Scripting.FileSystemObject"); 
	            var reader = fso.openTextFile(file, 1);
	        }
	        catch (e) {
	            alert("Internet Explore read local file error: \n" + e);
	        }
	    }else if(document.implementation && document.implementation.createDocument) {
	    	alert("请使用IE浏览器");
	    	return null;
	        try {
	            netscape.security.PrivilegeManager.enablePrivilege('UniversalXPConnect');
	            var lf = Components.classes["@mozilla.org/file/local;1"].createInstance(Components.interfaces.nsILocalFile);
	            lf.initWithPath(file);
	            if (lf.exists() == false) { 
	                alert("File does not exist"); 
	            }
	            var fis = Components.classes["@mozilla.org/network/file-input-stream;1"].createInstance(Components.interfaces.nsIFileInputStream); 
	            fis.init(lf, 0x01, 00004, null); 
	            var sis = Components.classes["@mozilla.org/scriptableinputstream;1"].createInstance(Components.interfaces.nsIScriptableInputStream); 
	            sis.init(fis); 
	            var converter = Components.classes["@mozilla.org/intl/scriptableunicodeconverter"].createInstance(Components.interfaces.nsIScriptableUnicodeConverter); 
	            converter.charset = "UTF-8"; 
	            content = converter.ConvertToUnicode(sis.read(sis.available()));
	        }
	        catch (e) {
	            alert("Mozilla Firefox read local file error: \n" + e);
	        } 
	    }
	    return fso;
	}

})();