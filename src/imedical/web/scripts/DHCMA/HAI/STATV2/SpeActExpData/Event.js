//页面Event
function InitDischPatientWinEvent(obj){	
	var fileArray = new Array();  //初始文件列表
	var xls=null;
	var xlBook=null;
	var xlSheet=null;
	var DischPatCnt="";
	var FilePath = "D:\\\\NIDP";    //默认导出目录
	
	obj.LoadEvent = function(args){
		//医院表格联动
		$HUI.combobox('#cboHosp',{
			onSelect:function(data){
				var HospID = data.ID;
				obj.gridDischPatientLoad();
			}
		});	
		
		//查询
		$('#btnQuery').on('click', function(){
			obj.btnQuery_click();
		});
		//导出
		$('#btnExport').on('click', function(){
			obj.btnExport_click();
		});
		//导出
		$('#btnExportDBF').on('click', function(){
			obj.btnExportDBF_click();
		});
	}
	
	obj.btnQuery_click = function() {	
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		if (Common_CompareDate(aDateFrom,aDateTo)>0) {
			$.messager.alert("提示","开始日期不能大于结束日期!");
			return;
		}
		if (Common_CompareDate(aDateFrom,Common_GetDate(new Date()))>0) {
			$.messager.alert("提示","开始日期不能大于当前日期!");
		}
		obj.gridDischPatientLoad();
	}
	

	//摘要信息
	obj.OpenView = function(aEpisodeID){
		var t=new Date();
		t=t.getTime();
		var strUrl = "./dhchai.ir.view.main.csp?PaadmID=" + aEpisodeID + "&PageType=WinOpen&t=" + t;
		websys_showModal({
			url:strUrl,
			title:'医院感染集成视图',
			iconCls:'icon-w-paper',  
			width:'95%',
			height:'95%'
		});
	}
	
		
	//加载患者明细
	obj.gridDischPatientLoad = function(){
		var HospIDs 	= $('#cboHospital').combobox('getValue');
		var DateFrom 	= $('#dtDateFrom').datebox('getValue');
		var DateTo		= $('#dtDateTo').datebox('getValue');
		
		obj.gridDischPatient.load({
		    ClassName:"DHCHAI.STATV2.SpeActSentHosp",
			QueryName:"QryinOutHosp",
			aHospIDs:HospIDs,
			aDateFrom:DateFrom,
			aDateTo:DateTo
	    });
    }
	
	
    //JSON导出csv数据
	var JSonToCSV = {
	    /*
	     * obj是一个对象，其中包含有：
	     * ## data 是导出的具体数据
	     * ## fileName 是导出时保存的文件名称 是string格式
	     * ## showLabel 表示是否显示表头 默认显示 是布尔格式
	     * ## columns 是表头对象，且title和key必须一一对应，包含有
	          title:[], // 表头展示的文字
	          key:[], // 获取数据的Key
	          formatter: function() // 自定义设置当前数据的 传入(key, value)
	     */
		setDataConver: function(obj) {   
			var data = obj['data'],
			ShowLabel = typeof obj['showLabel'] === 'undefined' ? true : obj['showLabel'],
			columns = obj['columns'] || {
			  title: [],
			  key: [],
			  formatter: undefined
			};
			var ShowLabel = typeof ShowLabel === 'undefined' ? true : ShowLabel;
			var row = "", CSV = '', key;
			// 如果要现实表头文字
			if (ShowLabel) {
			  // 如果有传入自定义的表头文字
			  if (columns.title.length) {
			      columns.title.map(function(n) {
			          row += n + '\t';
			      });
			  } else {
			      // 如果没有，就直接取数据第一条的对象的属性
			      for (key in data[0]) row += key + '\t';
			  }
			  row = row.slice(0, -1); // 删除最后一个\t号，即a\tb\t => a\tb
			  CSV += row + '\r\n'; // 添加换行符号
			}
			// 具体的数据处理
			data.map(function(n) {
			  row = '';
			  // 如果存在自定义key值
			  if (columns.key.length) {
			      columns.key.map(function(m) {
			          row += '' + (typeof columns.formatter === 'function' ? columns.formatter(m, n[m]) || n[m] : n[m]) + '\t';
			      });
			  } else {
			      for (key in n) {
			          row += '' + (typeof columns.formatter === 'function' ? columns.formatter(key, n[key]) || n[key] : n[key]) + '\t';
			      }
			  }
			  row.slice(0, row.length - 1); // 删除最后一个\t
			  CSV += row + '\r\n'; // 添加换行符号
			  
			});
			if(!CSV) return;
			return CSV;
		}
	}
	
	//转化为数组数据
	function toArray(rows,fields) {
        var data = [];
        var r = [];
        for(var i=0; i<fields.length; i++){
            r.push(fields[i]);
        }
        data.push(r);
        $.map(rows, function(row){
            var r = [];
            for(var i=0; i<fields.length; i++){
                r.push(row[fields[i]]);
            }
            data.push(r);
        });
        return data;
    }
	
	//获取日期时间后缀
    obj.GetDateTime  = function(){
	    var myDate = new Date();
	  	var y = myDate.getFullYear();
		var m = myDate.getMonth()+1;
		var d = myDate.getDate();
	    var ymd = y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	
		var h = myDate.getHours();
		var m = myDate.getMinutes();
		var s = myDate.getSeconds();
		var hms=(h<10?('0'+h):h)+':'+(m<10?('0'+m):m)+':'+(s<10?('0'+s):s);
		
		return ymd+' '+hms;
    }
	//导出
	obj.btnExport_click = function(){
		
		//1.抽取需对照的项目数据
		var flg = $m({
			ClassName:'DHCHAI.MAPS.MappingSrv',
			MethodName:'SynSourceData'
		},false);
		
		//2.判断是否有未对照的有效记录
		var ret =$m({
			ClassName:"DHCHAI.MAPS.MappingSrv",
			MethodName:"GetIsUnMap",
		}, false);
		if (parseInt(ret)==1) {
			$.messager.confirm("提示", "存在未对照的数据，请先完成数据对照！", function(r){			
				if (r){
					window.parent.$('#divTabs').tabs('select','数据对照');   //跳转至数据对照界面				
				}
			});
			return;
		}
	
		//3.执行导出压缩包
		fileArray = [];  //初始文件列表
		if(!obj.inOutHosp(1)) return false;
		if(!obj.deptList(1)) return false;
		if(!obj.infectList(1)) return false;
		if(!obj.inspecteList(1)) return false;
		if(!obj.antibiList(1)) return false;
		if (DischPatCnt>0) {
			obj.packInfo(DischPatCnt,ServerObj.HospUnitID,1);
		}
		obj.BatchZip();
		
		return true;
	}
	
	//导出DBF文件
	obj.btnExportDBF_click = function(){
		//1.删除D:\\NIDP下导出的文件（防止导出时提示是否覆盖及覆盖内容错误）
		obj.DeleteFile(FilePath);
		
		//2.抽取需对照的项目数据
		var flg = $m({
			ClassName:'DHCHAI.MAPS.MappingSrv',
			MethodName:'SynSourceData'
		},false);
		
		//3.判断是否有未对照的有效记录
		var ret =$m({
			ClassName:"DHCHAI.MAPS.MappingSrv",
			MethodName:"GetIsUnMap",
		}, false);
		if (parseInt(ret)==1) {
			$.messager.confirm("提示", "存在未对照的数据，请先完成数据对照！", function(r){			
				if (r){
					window.parent.$('#divTabs').tabs('select','数据对照');   //跳转至数据对照界面				
				}
			});
			return;
		}
	
			
		//4.创建导出目录
		setTimeout(function() { 
			obj.CreatePath(FilePath);
		}, 1000); 
		 
		//5.导出dbf文件	
		setTimeout(function() { 
			if(!obj.inOutHosp()) return false;	
			if (DischPatCnt>0) {
				obj.packInfo(DischPatCnt,ServerObj.HospUnitID,"");
				$.messager.progress({
					title: "提示",
					msg: '正在导出dbf数据文件，请耐心等候',
					interval:30000,
				});	
			}	
			if(!obj.deptList()) return false;
			if(!obj.infectList()) return false;
			if(!obj.inspecteList()) return false;
			if(!obj.antibiList()) return false;			
		}, 5000); 
	   	
		//6.dbf压缩导出	
		setTimeout(function() { 
			//等待文件导出完成（默认5分钟）
			$.messager.progress("close");
			obj.SelectFile();			
		}, 300000);   
		return true;
	}
    
	//窗体
	obj.SelectFile = function(){
		var strURL='../scripts/DHCMA/HAI/zip/exportzip.html?UnitID='+ServerObj.HospUnitID;
		if (BrowserVer=="isLessIE11") {
			return;
		}else if(BrowserVer=="isIE11") {
			strURL='../scripts/DHCMA/HAI/zip/exportzip-ie.html?UnitID='+ServerObj.HospUnitID;		
		}else if(BrowserVer=="isChrome") {   //医为浏览器为 Chrome 49版本不支持ES6,  Chrome 58+才支持ES6
			var userAgent = navigator.userAgent;
            var ChromePos = userAgent.indexOf("Chrome");  //Chrome定位
            var ChromeStr = userAgent.substr(ChromePos);  //Chrome串
            var ChromeArr = ChromeStr.split(" ");
            var ChromeVer = parseInt(ChromeArr[0].split("/")[1]);      //Chrome版本
            if (ChromeVer<=58) {    //低于58的按IE方法处理
           		strURL='../scripts/DHCMA/HAI/zip/exportzip-ie.html?UnitID='+ServerObj.HospUnitID+'&Browser=1';		
            }
		}
		websys_showModal({
			url:strURL,
			title:'导出压缩包',
			iconCls:'icon-w-paper',     
			width:680,
			height:520
		});	
		return true;
	}
	
    //6.2 摘要表(packInfo)文件	
	obj.packInfo =function(aCount,aunitId,aType) {
		var dateFrom = $('#dtDateFrom').datebox('getValue');
		var dateTo = $('#dtDateTo').datebox('getValue');
		var note = $('#dtDateFrom').datebox('getValue').split("-")[0]+"年"+ $('#dtDateFrom').datebox('getValue').split("-")[1]+"月的院感过程化数据"
		var dateTime = obj.GetDateTime();
		var nidpSn= new Date().getTime();
		var fields  =  ['nidpSn','type','dateFrom','dateTo','note','exportDate','caseCount','unitId'];
		var dataList=[{'nidpSn':nidpSn,'type':'1','dateFrom':dateFrom,'dateTo':dateTo,'note':note,'exportDate':dateTime,'caseCount':aCount,'unitId':aunitId}];
		
		if (aType==1) { //导出Excel
			var ret = obj.ExportXLS(dataList,fields,'packInfo');
		}else {
			var arrData = toArray(dataList,fields);
			var Row = arrData.length;
			var Col = fields.length;
			var ret =obj.ExportDBF(arrData,Row,Col,'packInfo');
		}			
		return ret;
	}
	
	//6.3 科室表(deptList)文件
	obj.deptList = function(aType) {
		var strTmp =$m({
			ClassName:"DHCHAI.STATV2.SpeActSentHosp",
			QueryName:"QryDeptList",
			ResultSetType:'array',
			aHospIDs:$('#cboHospital').combobox('getValue'),
			aLocType:'E',
		}, false);
		if (!strTmp) return false;     
		var strList = JSON.parse(strTmp);
		var fields  =  ['depCode', 'depName', 'icu', 'newborn'];
		
		if (aType==1) { //导出Excel
			var ret =obj.ExportXLS(strList,fields,'deptList');
		}else {
			var arrData = toArray(strList,fields);
			var Row = strList.length;
			var Col = fields.length;
			var ret = obj.ExportDBF(arrData,Row+1,Col,'deptList');
		}			
		return ret;
	}
	//6.4 患者表(inOutHosp)文件
	obj.inOutHosp = function(aType) {
		var strTmp =$cm({
			ClassName:"DHCHAI.STATV2.SpeActSentHosp",
			QueryName:"QryinOutHosp",
			aHospIDs:$('#cboHospital').combobox('getValue'),
			aDateFrom:$('#dtDateFrom').datebox('getValue'),
			aDateTo:$('#dtDateTo').datebox('getValue'),	
			page:1,
			rows:9999999			
		}, false);
	    
		if (!strTmp) return false;     
		DischPatCnt = strTmp.total;
		var strList = strTmp.rows;
		if (DischPatCnt<1) {
			$.messager.popover({msg: '无住院患者数据需导出！',type:'success',timeout: 3000});
			return; 
		}			
		var fields  =  ['zyid','visitId','patientId','sex','birthDay','inHospAt','outHospAt','outDeptId','inHospDig','outDig','otherDig'];
		
		if (aType==1) { //导出Excel
			var ret =obj.ExportXLS(strList,fields,'inOutHosp');
		}else {
			var arrData = toArray(strList,fields);
			var Row = strList.length;
			var Col = fields.length;
			var ret =obj.ExportDBF(arrData,Row+1,Col,'inOutHosp');	
		}
		return ret;
	}
	

	//6.5 感染表(infectList)文件
	obj.infectList = function(aType) {
		var strTmp =$cm({
			ClassName:"DHCHAI.STATV2.SpeActSentHosp",
			QueryName:"QryInfectList",
			aHospIDs:$('#cboHospital').combobox('getValue'),
			aDateFrom:$('#dtDateFrom').datebox('getValue'),
			aDateTo:$('#dtDateTo').datebox('getValue'),
			page:1,
			rows:9999999			
		}, false);
	    
		if (!strTmp) return false;     
		var strList = strTmp.rows;
		var fields  =  ['zyid','infectCode','infectName','infectDate','conDate','reportDate','infectType','infectDept','interCode'];
		
		if (aType==1) { //导出Excel
			var ret = obj.ExportXLS(strList,fields,'infectList');
		}else {
			var arrData = toArray(strList,fields);
			var Row = strList.length;
			var Col = fields.length;
			var ret = obj.ExportDBF(arrData,Row+1,Col,'infectList');
		}
		return ret;
	}
	//6.6 送检表(inspecteList)文件
	obj.inspecteList = function(aType) {
		var strTmp =$cm({
			ClassName:"DHCHAI.STATV2.SpeActSentHosp",
			QueryName:"QryInspecteList",
			aHospIDs:$('#cboHospital').combobox('getValue'),
			aDateFrom:$('#dtDateFrom').datebox('getValue'),
			aDateTo:$('#dtDateTo').datebox('getValue'),
			page:1,
			rows:9999999			
		}, false);
	    
		if (!strTmp) return false;     
		var strList = strTmp.rows;
		var fields  =  ['zyid','testNo','typeCode','typeName','sourceName','itemCode','itemName','submitAt','infectId','interCode'];
		if (aType==1) { //导出Excel
			var ret = obj.ExportXLS(strList,fields,'inspecteList');
		}else {
			var arrData = toArray(strList,fields);
			var Row = strList.length;
			var Col = fields.length;
			var ret = obj.ExportDBF(arrData,Row+1,Col,'inspecteList');
		}
		return ret;
	}
	//6.7 抗菌药物表(antibiList)
	obj.antibiList = function(aType) {
		var strTmp =$cm({
			ClassName:"DHCHAI.STATV2.SpeActSentHosp",
			QueryName:"QryAntibiList",
			aHospIDs:$('#cboHospital').combobox('getValue'),
			aDateFrom:$('#dtDateFrom').datebox('getValue'),
			aDateTo:$('#dtDateTo').datebox('getValue'),
			page:1,
			rows:9999999			
		}, false);
	    
		if (!strTmp) return false;     
		var strList = strTmp.rows;
		var fields  =  ['zyid','orderAt','stopAt','orderId','orderName','routeId','usePurpose','drugLine','interCode','execAt'];
		if (aType==1) { //导出Excel
			var ret =obj.ExportXLS(strList,fields,'antibiList');
		}else {
			var arrData = toArray(strList,fields);
			var Row = strList.length;
			var Col = fields.length;
			var ret = obj.ExportDBF(arrData,Row+1,Col,'antibiList');
		}
		return ret;
	}
	
	//导出excel、csv
	obj.ExportXLS = function(aData,atitle,aFileName) {	
		var arrayFile = JSonToCSV.setDataConver({
			data: aData,
			//showLabel:false,
			columns: {
				 title: atitle,  //表头
				 key: atitle
				,formatter: function(n, v) {
					if(v === undefined){
						return " ";
					}
			    }
			}
		});
        fileArray.push({name:aFileName,data:arrayFile});  //追加文件列表 
		return true;
	}
	
	//基于Excel.Application导出
	obj.ExportDBF = function(aData,aRow,aCol,aFileName) {	
		if ("undefined"==typeof EnableLocalWeb ||0==EnableLocalWeb ||(BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) {	
			try {
				xls = new ActiveXObject ("Excel.Application");
			}catch(e) {
				$.messager.alert("提示","创建Excel应用对象失败!\n\n如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。\n\n具体操作：\n\n"+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用。\n\n如果当前为Chrome浏览器，请检查中间件是否启用、运行！",'info');
				return false;
			}
			xlBook=xls.Workbooks.Add();
			xlSheet=xlBook.ActiveSheet;
			fillxlSheet(xlSheet,aData,aRow,aCol);
			xls.DisplayAlerts = false;
			xlBook.SaveAs(FilePath+"\\\\"+aFileName+'.dbf',11);
			xls.DisplayAlerts = true;
			xls.visible=false;
			xlSheet=null;
			xlBook.Close(savechanges=true);
			xls.Quit();
			xlSheet=null;
			xlBook=null;
			xls=null;
			xlSheet=true;
			return true;
		}else{
		   //中间件运行
		    var ListString=fillxlSheetStr(aData,aRow,aCol);
			var Str ="(function test(x){"
				Str += "var xlApp = new ActiveXObject('Excel.Application');"
				Str += "xlBook=xlApp.Workbooks.add;"  
				Str += "xlSheet=xlBook.ActiveSheet;"
				Str += ListString
				Str += "xlApp.DisplayAlerts = false;"    //文件已存在，不提示另存，直接覆盖
				Str += "xlSheet.SaveAs('"+FilePath+"\\\\"+aFileName+".dbf',11);"
				Str += "xlApp.DisplayAlerts = true;"     //放开另存提示
				Str += "xlApp.Visible = false;"
				Str += "xlApp.UserControl = false;"			
				Str += "xlBook.Close(savechanges=true);"
				Str += "xlApp.Quit();"
				Str += "xlSheet=null;"
				Str += "xlBook=null;"
				Str += "xlApp=null;"
				Str += "xlSheet=true;"
				Str += "return 1;}());";
			//以上为拼接字符串
			CmdShell.notReturn =0;   
			var rtn = CmdShell.CurrentUserEvalJs(Str);   //通过中间件运行打印程序 
		
			if (rtn.status == "200") {
				return true;
			}else {
				return false;
			}			
		}	
	}
	
	
	//创建存放目录
	obj.CreatePath = function(Path) {
		if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11"||(BrowserVer=="isLessIE11")||(BrowserVer=="isIE11"))) { //IE浏览器
			var objFSO = new ActiveXObject("Scripting.FileSystemObject");
			var arryFolder = Path.split("\\");
			var strPath = arryFolder[0];
			var blnReturn = false;
			try {
				for(var i = 1; i < arryFolder.length; i ++)
				{
					if(arryFolder[i] == "") continue;
					strPath += "\\\\" + arryFolder[i];
					if(!objFSO.FolderExists(strPath))
						objFSO.CreateFolder(strPath);
				}
				blnReturn = true;
			}catch(err) {
				blnReturn = false;
			}
			objFSO = null;
			return blnReturn;
		}else{	
			if (EnableLocalWeb==1) {  //非IE浏览器，且启用中间件
				var arryFolder = Path.split("\\");
				var strPath = arryFolder[0];
				var blnReturn = false;		
				
				var Str ="(function test(x){"+ '\n' 
		    	Str +="var objFSO = new ActiveXObject('Scripting.FileSystemObject');"+ '\n'
				for(var i = 1; i < arryFolder.length; i ++)
				{
					if(arryFolder[i] == "") continue;
					strPath += "\\\\" + arryFolder[i];			
					Str +="		if(!objFSO.FolderExists('"+strPath+"')){"+ '\n'  
					Str +="			objFSO.CreateFolder('"+strPath+"');"+ '\n'  //为兼容谷歌下层级正常导出，一定是“\\\\”,标点符号很重要，值都是''引起来才能使用
					Str +="		}"+ '\n'				
				}
			    Str += "return 1;}());";
				CmdShell.notReturn =0;  							
				var rtn = CmdShell.CurrentUserEvalJs(Str);   //通过中间件创建目录
	
				if (rtn.status=="200") {
					blnReturn = true;
				}else {
					blnReturn = false;
				}
				
				objFSO = null;
				return blnReturn;
			}
		}
	}	
	
	//判断目录下的文件是否存在 
	obj.IsExistFile = function (filepath, filename){
		if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11"||(BrowserVer=="isLessIE11")||(BrowserVer=="isIE11"))) { //IE浏览器
			var objFSO = new ActiveXObject("Scripting.FileSystemObject");
		
			var blnReturn = false;
			try {		
				if(objFSO.FileExists(filepath+"\\\\"+filename))
				blnReturn = true;
			}catch(err) {
				blnReturn = false;
			}
			objFSO = null;
			return blnReturn;
		}else{	
			if (EnableLocalWeb==1) {  //非IE浏览器，且启用中间件
				var blnReturn = false;		
				
				var Str ="(function test(x){"+ '\n' 
		    	Str +="var objFSO = new ActiveXObject('Scripting.FileSystemObject');"+ '\n'	
				Str +="		if(objFSO.FileExists('"+filepath+"\\\\"+filename+"')){"+ '\n'  
				Str +="		}"+ '\n'						
			    Str += "return 1;}());";
				CmdShell.notReturn =0;   
				var rtn = CmdShell.CurrentUserEvalJs(Str);   //通过中间件运行
				if (rtn.status==200) {
					blnReturn = true;
				}else {
					blnReturn = false;
				}
				
				objFSO = null;
				return blnReturn;
			}
		}
	}
	
	//删除存放目录中的文件
	obj.DeleteFile = function(Path) {
		if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11"||(BrowserVer=="isLessIE11")||(BrowserVer=="isIE11"))) { //IE浏览器
			var objFSO = new ActiveXObject("Scripting.FileSystemObject");
		
			var blnReturn = false;
			try {		
				if(objFSO.FolderExists(Path))
					objFSO.DeleteFile(Path+'\\\\*');
				blnReturn = true;
			}catch(err) {
				blnReturn = false;
			}
			objFSO = null;
			return blnReturn;
		}else{	
			if (EnableLocalWeb==1) {  //非IE浏览器，且启用中间件
				var blnReturn = false;		
				
				var Str ="(function test(x){"+ '\n' 
		    	Str +="var objFSO = new ActiveXObject('Scripting.FileSystemObject');"+ '\n'	
				Str +="		if(objFSO.FolderExists('"+Path+"')){"+ '\n'  
				Str +="			objFSO.DeleteFile('"+Path+"\\\\*');"+ '\n'  //为兼容谷歌下层级正常导出，一定是“\\\\”,标点符号很重要，值都是''引起来才能使用
				Str +="		}"+ '\n'						
			    Str += "return 1;}());";
				CmdShell.notReturn =0;   
				var rtn = CmdShell.CurrentUserEvalJs(Str);   //通过中间件运行删除目录
				if (rtn.status==200) {
					blnReturn = true;
				}else {
					blnReturn = false;
				}
				
				objFSO = null;
				return blnReturn;
			}
		}
	}	
	function fillxlSheet(xlSheet,cData,cRow,cCol)
	{
		var cells = xlSheet.Cells;
		if ((cRow=="")||(typeof(cRow)=="undefined")){cRow=1;}
		if ((cCol=="")||(typeof(cCol)=="undefined")){cCol=1;}
		for(var i=0; i<cRow; ++i)
		{
			for(var j=0; j<cCol; ++j)
			{
				//设置单元格格式（文本）
				cells((i+1),(j+1)).NumberFormatLocal = "@";
				//给单元格赋值
				cells((i+1),(j+1)).Value = cData[i][j];
			}
		}
		return cells;
	}

	function fillxlSheetStr(cData,cRow,cCol)
	{
		var ListString="";
		if ((cRow=="")||(typeof(cRow)=="undefined")){cRow=1;}
		if ((cCol=="")||(typeof(cCol)=="undefined")){cCol=1;}
		for(var i=0; i<cRow; ++i)
		{
			for(var j=0; j<cCol; ++j)
			{
				
				ListString=ListString+ "xlSheet.Cells("+(i+1)+","+(j+1)+").NumberFormatLocal = '@';"  //设置单元格格式（文本）
				ListString=ListString+ "xlSheet.Cells("+(i+1)+","+(j+1)+").Value='"+cData[i][j]+"';"  //标点符号很重要，一个都不能少
			}
		}
		return ListString; 
	}
	
	
	//压缩
	obj.BatchZip = function () {  //打包压缩文件
		var JSzip = new JSZip();	
		var ExportTime = new Date().getTime()*1000;   //当前毫秒数	 
	   
		//文件打包
	    for (var i = 0; i < fileArray.length; i++) {
	        var fileObj = fileArray[i];
	        JSzip.file(fileObj.name+".xls", fileObj.data) // 逐个添加信息文件
	    }
		
		JSzip.generateAsync({type: 'blob'}).then(function(content) {
		    var filename = "NIDP-"+ExportTime+ '.zip'; 
		    saveAs(content, filename);
		}); 
	}

}
