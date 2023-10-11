//ҳ��Event
function InitDischPatientWinEvent(obj){	
	var fileArray = new Array();  //��ʼ�ļ��б�
	var xls=null;
	var xlBook=null;
	var xlSheet=null;
	var DischPatCnt="";
	var FilePath = "D:\\\\NIDP";    //Ĭ�ϵ���Ŀ¼
	
	obj.LoadEvent = function(args){
		//ҽԺ�������
		$HUI.combobox('#cboHosp',{
			onSelect:function(data){
				var HospID = data.ID;
				obj.gridDischPatientLoad();
			}
		});	
		
		//��ѯ
		$('#btnQuery').on('click', function(){
			obj.btnQuery_click();
		});
		//����
		$('#btnExport').on('click', function(){
			obj.btnExport_click();
		});
		//����
		$('#btnExportDBF').on('click', function(){
			obj.btnExportDBF_click();
		});
	}
	
	obj.btnQuery_click = function() {	
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		if (Common_CompareDate(aDateFrom,aDateTo)>0) {
			$.messager.alert("��ʾ","��ʼ���ڲ��ܴ��ڽ�������!");
			return;
		}
		if (Common_CompareDate(aDateFrom,Common_GetDate(new Date()))>0) {
			$.messager.alert("��ʾ","��ʼ���ڲ��ܴ��ڵ�ǰ����!");
		}
		obj.gridDischPatientLoad();
	}
	

	//ժҪ��Ϣ
	obj.OpenView = function(aEpisodeID){
		var t=new Date();
		t=t.getTime();
		var strUrl = "./dhchai.ir.view.main.csp?PaadmID=" + aEpisodeID + "&PageType=WinOpen&t=" + t;
		websys_showModal({
			url:strUrl,
			title:'ҽԺ��Ⱦ������ͼ',
			iconCls:'icon-w-paper',  
			width:'95%',
			height:'95%'
		});
	}
	
		
	//���ػ�����ϸ
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
	
	
    //JSON����csv����
	var JSonToCSV = {
	    /*
	     * obj��һ���������а����У�
	     * ## data �ǵ����ľ�������
	     * ## fileName �ǵ���ʱ������ļ����� ��string��ʽ
	     * ## showLabel ��ʾ�Ƿ���ʾ��ͷ Ĭ����ʾ �ǲ�����ʽ
	     * ## columns �Ǳ�ͷ������title��key����һһ��Ӧ��������
	          title:[], // ��ͷչʾ������
	          key:[], // ��ȡ���ݵ�Key
	          formatter: function() // �Զ������õ�ǰ���ݵ� ����(key, value)
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
			// ���Ҫ��ʵ��ͷ����
			if (ShowLabel) {
			  // ����д����Զ���ı�ͷ����
			  if (columns.title.length) {
			      columns.title.map(function(n) {
			          row += n + '\t';
			      });
			  } else {
			      // ���û�У���ֱ��ȡ���ݵ�һ���Ķ��������
			      for (key in data[0]) row += key + '\t';
			  }
			  row = row.slice(0, -1); // ɾ�����һ��\t�ţ���a\tb\t => a\tb
			  CSV += row + '\r\n'; // ��ӻ��з���
			}
			// ��������ݴ���
			data.map(function(n) {
			  row = '';
			  // ��������Զ���keyֵ
			  if (columns.key.length) {
			      columns.key.map(function(m) {
			          row += '' + (typeof columns.formatter === 'function' ? columns.formatter(m, n[m]) || n[m] : n[m]) + '\t';
			      });
			  } else {
			      for (key in n) {
			          row += '' + (typeof columns.formatter === 'function' ? columns.formatter(key, n[key]) || n[key] : n[key]) + '\t';
			      }
			  }
			  row.slice(0, row.length - 1); // ɾ�����һ��\t
			  CSV += row + '\r\n'; // ��ӻ��з���
			  
			});
			if(!CSV) return;
			return CSV;
		}
	}
	
	//ת��Ϊ��������
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
	
	//��ȡ����ʱ���׺
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
	//����
	obj.btnExport_click = function(){
		
		//1.��ȡ����յ���Ŀ����
		var flg = $m({
			ClassName:'DHCHAI.MAPS.MappingSrv',
			MethodName:'SynSourceData'
		},false);
		
		//2.�ж��Ƿ���δ���յ���Ч��¼
		var ret =$m({
			ClassName:"DHCHAI.MAPS.MappingSrv",
			MethodName:"GetIsUnMap",
		}, false);
		if (parseInt(ret)==1) {
			$.messager.confirm("��ʾ", "����δ���յ����ݣ�����������ݶ��գ�", function(r){			
				if (r){
					window.parent.$('#divTabs').tabs('select','���ݶ���');   //��ת�����ݶ��ս���				
				}
			});
			return;
		}
	
		//3.ִ�е���ѹ����
		fileArray = [];  //��ʼ�ļ��б�
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
	
	//����DBF�ļ�
	obj.btnExportDBF_click = function(){
		//1.ɾ��D:\\NIDP�µ������ļ�����ֹ����ʱ��ʾ�Ƿ񸲸Ǽ��������ݴ���
		obj.DeleteFile(FilePath);
		
		//2.��ȡ����յ���Ŀ����
		var flg = $m({
			ClassName:'DHCHAI.MAPS.MappingSrv',
			MethodName:'SynSourceData'
		},false);
		
		//3.�ж��Ƿ���δ���յ���Ч��¼
		var ret =$m({
			ClassName:"DHCHAI.MAPS.MappingSrv",
			MethodName:"GetIsUnMap",
		}, false);
		if (parseInt(ret)==1) {
			$.messager.confirm("��ʾ", "����δ���յ����ݣ�����������ݶ��գ�", function(r){			
				if (r){
					window.parent.$('#divTabs').tabs('select','���ݶ���');   //��ת�����ݶ��ս���				
				}
			});
			return;
		}
	
			
		//4.��������Ŀ¼
		setTimeout(function() { 
			obj.CreatePath(FilePath);
		}, 1000); 
		 
		//5.����dbf�ļ�	
		setTimeout(function() { 
			if(!obj.inOutHosp()) return false;	
			if (DischPatCnt>0) {
				obj.packInfo(DischPatCnt,ServerObj.HospUnitID,"");
				$.messager.progress({
					title: "��ʾ",
					msg: '���ڵ���dbf�����ļ��������ĵȺ�',
					interval:30000,
				});	
			}	
			if(!obj.deptList()) return false;
			if(!obj.infectList()) return false;
			if(!obj.inspecteList()) return false;
			if(!obj.antibiList()) return false;			
		}, 5000); 
	   	
		//6.dbfѹ������	
		setTimeout(function() { 
			//�ȴ��ļ�������ɣ�Ĭ��5���ӣ�
			$.messager.progress("close");
			obj.SelectFile();			
		}, 300000);   
		return true;
	}
    
	//����
	obj.SelectFile = function(){
		var strURL='../scripts/DHCMA/HAI/zip/exportzip.html?UnitID='+ServerObj.HospUnitID;
		if (BrowserVer=="isLessIE11") {
			return;
		}else if(BrowserVer=="isIE11") {
			strURL='../scripts/DHCMA/HAI/zip/exportzip-ie.html?UnitID='+ServerObj.HospUnitID;		
		}else if(BrowserVer=="isChrome") {   //ҽΪ�����Ϊ Chrome 49�汾��֧��ES6,  Chrome 58+��֧��ES6
			var userAgent = navigator.userAgent;
            var ChromePos = userAgent.indexOf("Chrome");  //Chrome��λ
            var ChromeStr = userAgent.substr(ChromePos);  //Chrome��
            var ChromeArr = ChromeStr.split(" ");
            var ChromeVer = parseInt(ChromeArr[0].split("/")[1]);      //Chrome�汾
            if (ChromeVer<=58) {    //����58�İ�IE��������
           		strURL='../scripts/DHCMA/HAI/zip/exportzip-ie.html?UnitID='+ServerObj.HospUnitID+'&Browser=1';		
            }
		}
		websys_showModal({
			url:strURL,
			title:'����ѹ����',
			iconCls:'icon-w-paper',     
			width:680,
			height:520
		});	
		return true;
	}
	
    //6.2 ժҪ��(packInfo)�ļ�	
	obj.packInfo =function(aCount,aunitId,aType) {
		var dateFrom = $('#dtDateFrom').datebox('getValue');
		var dateTo = $('#dtDateTo').datebox('getValue');
		var note = $('#dtDateFrom').datebox('getValue').split("-")[0]+"��"+ $('#dtDateFrom').datebox('getValue').split("-")[1]+"�µ�Ժ�й��̻�����"
		var dateTime = obj.GetDateTime();
		var nidpSn= new Date().getTime();
		var fields  =  ['nidpSn','type','dateFrom','dateTo','note','exportDate','caseCount','unitId'];
		var dataList=[{'nidpSn':nidpSn,'type':'1','dateFrom':dateFrom,'dateTo':dateTo,'note':note,'exportDate':dateTime,'caseCount':aCount,'unitId':aunitId}];
		
		if (aType==1) { //����Excel
			var ret = obj.ExportXLS(dataList,fields,'packInfo');
		}else {
			var arrData = toArray(dataList,fields);
			var Row = arrData.length;
			var Col = fields.length;
			var ret =obj.ExportDBF(arrData,Row,Col,'packInfo');
		}			
		return ret;
	}
	
	//6.3 ���ұ�(deptList)�ļ�
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
		
		if (aType==1) { //����Excel
			var ret =obj.ExportXLS(strList,fields,'deptList');
		}else {
			var arrData = toArray(strList,fields);
			var Row = strList.length;
			var Col = fields.length;
			var ret = obj.ExportDBF(arrData,Row+1,Col,'deptList');
		}			
		return ret;
	}
	//6.4 ���߱�(inOutHosp)�ļ�
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
			$.messager.popover({msg: '��סԺ���������赼����',type:'success',timeout: 3000});
			return; 
		}			
		var fields  =  ['zyid','visitId','patientId','sex','birthDay','inHospAt','outHospAt','outDeptId','inHospDig','outDig','otherDig'];
		
		if (aType==1) { //����Excel
			var ret =obj.ExportXLS(strList,fields,'inOutHosp');
		}else {
			var arrData = toArray(strList,fields);
			var Row = strList.length;
			var Col = fields.length;
			var ret =obj.ExportDBF(arrData,Row+1,Col,'inOutHosp');	
		}
		return ret;
	}
	

	//6.5 ��Ⱦ��(infectList)�ļ�
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
		
		if (aType==1) { //����Excel
			var ret = obj.ExportXLS(strList,fields,'infectList');
		}else {
			var arrData = toArray(strList,fields);
			var Row = strList.length;
			var Col = fields.length;
			var ret = obj.ExportDBF(arrData,Row+1,Col,'infectList');
		}
		return ret;
	}
	//6.6 �ͼ��(inspecteList)�ļ�
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
		if (aType==1) { //����Excel
			var ret = obj.ExportXLS(strList,fields,'inspecteList');
		}else {
			var arrData = toArray(strList,fields);
			var Row = strList.length;
			var Col = fields.length;
			var ret = obj.ExportDBF(arrData,Row+1,Col,'inspecteList');
		}
		return ret;
	}
	//6.7 ����ҩ���(antibiList)
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
		if (aType==1) { //����Excel
			var ret =obj.ExportXLS(strList,fields,'antibiList');
		}else {
			var arrData = toArray(strList,fields);
			var Row = strList.length;
			var Col = fields.length;
			var ret = obj.ExportDBF(arrData,Row+1,Col,'antibiList');
		}
		return ret;
	}
	
	//����excel��csv
	obj.ExportXLS = function(aData,atitle,aFileName) {	
		var arrayFile = JSonToCSV.setDataConver({
			data: aData,
			//showLabel:false,
			columns: {
				 title: atitle,  //��ͷ
				 key: atitle
				,formatter: function(n, v) {
					if(v === undefined){
						return " ";
					}
			    }
			}
		});
        fileArray.push({name:aFileName,data:arrayFile});  //׷���ļ��б� 
		return true;
	}
	
	//����Excel.Application����
	obj.ExportDBF = function(aData,aRow,aCol,aFileName) {	
		if ("undefined"==typeof EnableLocalWeb ||0==EnableLocalWeb ||(BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) {	
			try {
				xls = new ActiveXObject ("Excel.Application");
			}catch(e) {
				$.messager.alert("��ʾ","����ExcelӦ�ö���ʧ��!\n\n�����ȷ�����ĵ������Ѿ���װ��Excel��"+"��ô�����IE�İ�ȫ����\n\n���������\n\n"+"���� �� Internetѡ�� �� ��ȫ �� �Զ��弶�� �� ��û�б��Ϊ��ȫ��ActiveX���г�ʼ���ͽű����� �� ���á�\n\n�����ǰΪChrome������������м���Ƿ����á����У�",'info');
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
		   //�м������
		    var ListString=fillxlSheetStr(aData,aRow,aCol);
			var Str ="(function test(x){"
				Str += "var xlApp = new ActiveXObject('Excel.Application');"
				Str += "xlBook=xlApp.Workbooks.add;"  
				Str += "xlSheet=xlBook.ActiveSheet;"
				Str += ListString
				Str += "xlApp.DisplayAlerts = false;"    //�ļ��Ѵ��ڣ�����ʾ��棬ֱ�Ӹ���
				Str += "xlSheet.SaveAs('"+FilePath+"\\\\"+aFileName+".dbf',11);"
				Str += "xlApp.DisplayAlerts = true;"     //�ſ������ʾ
				Str += "xlApp.Visible = false;"
				Str += "xlApp.UserControl = false;"			
				Str += "xlBook.Close(savechanges=true);"
				Str += "xlApp.Quit();"
				Str += "xlSheet=null;"
				Str += "xlBook=null;"
				Str += "xlApp=null;"
				Str += "xlSheet=true;"
				Str += "return 1;}());";
			//����Ϊƴ���ַ���
			CmdShell.notReturn =0;   
			var rtn = CmdShell.CurrentUserEvalJs(Str);   //ͨ���м�����д�ӡ���� 
		
			if (rtn.status == "200") {
				return true;
			}else {
				return false;
			}			
		}	
	}
	
	
	//�������Ŀ¼
	obj.CreatePath = function(Path) {
		if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11"||(BrowserVer=="isLessIE11")||(BrowserVer=="isIE11"))) { //IE�����
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
			if (EnableLocalWeb==1) {  //��IE��������������м��
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
					Str +="			objFSO.CreateFolder('"+strPath+"');"+ '\n'  //Ϊ���ݹȸ��²㼶����������һ���ǡ�\\\\��,�����ź���Ҫ��ֵ����''����������ʹ��
					Str +="		}"+ '\n'				
				}
			    Str += "return 1;}());";
				CmdShell.notReturn =0;  							
				var rtn = CmdShell.CurrentUserEvalJs(Str);   //ͨ���м������Ŀ¼
	
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
	
	//�ж�Ŀ¼�µ��ļ��Ƿ���� 
	obj.IsExistFile = function (filepath, filename){
		if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11"||(BrowserVer=="isLessIE11")||(BrowserVer=="isIE11"))) { //IE�����
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
			if (EnableLocalWeb==1) {  //��IE��������������м��
				var blnReturn = false;		
				
				var Str ="(function test(x){"+ '\n' 
		    	Str +="var objFSO = new ActiveXObject('Scripting.FileSystemObject');"+ '\n'	
				Str +="		if(objFSO.FileExists('"+filepath+"\\\\"+filename+"')){"+ '\n'  
				Str +="		}"+ '\n'						
			    Str += "return 1;}());";
				CmdShell.notReturn =0;   
				var rtn = CmdShell.CurrentUserEvalJs(Str);   //ͨ���м������
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
	
	//ɾ�����Ŀ¼�е��ļ�
	obj.DeleteFile = function(Path) {
		if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11"||(BrowserVer=="isLessIE11")||(BrowserVer=="isIE11"))) { //IE�����
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
			if (EnableLocalWeb==1) {  //��IE��������������м��
				var blnReturn = false;		
				
				var Str ="(function test(x){"+ '\n' 
		    	Str +="var objFSO = new ActiveXObject('Scripting.FileSystemObject');"+ '\n'	
				Str +="		if(objFSO.FolderExists('"+Path+"')){"+ '\n'  
				Str +="			objFSO.DeleteFile('"+Path+"\\\\*');"+ '\n'  //Ϊ���ݹȸ��²㼶����������һ���ǡ�\\\\��,�����ź���Ҫ��ֵ����''����������ʹ��
				Str +="		}"+ '\n'						
			    Str += "return 1;}());";
				CmdShell.notReturn =0;   
				var rtn = CmdShell.CurrentUserEvalJs(Str);   //ͨ���м������ɾ��Ŀ¼
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
				//���õ�Ԫ���ʽ���ı���
				cells((i+1),(j+1)).NumberFormatLocal = "@";
				//����Ԫ��ֵ
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
				
				ListString=ListString+ "xlSheet.Cells("+(i+1)+","+(j+1)+").NumberFormatLocal = '@';"  //���õ�Ԫ���ʽ���ı���
				ListString=ListString+ "xlSheet.Cells("+(i+1)+","+(j+1)+").Value='"+cData[i][j]+"';"  //�����ź���Ҫ��һ����������
			}
		}
		return ListString; 
	}
	
	
	//ѹ��
	obj.BatchZip = function () {  //���ѹ���ļ�
		var JSzip = new JSZip();	
		var ExportTime = new Date().getTime()*1000;   //��ǰ������	 
	   
		//�ļ����
	    for (var i = 0; i < fileArray.length; i++) {
	        var fileObj = fileArray[i];
	        JSzip.file(fileObj.name+".xls", fileObj.data) // ��������Ϣ�ļ�
	    }
		
		JSzip.generateAsync({type: 'blob'}).then(function(content) {
		    var filename = "NIDP-"+ExportTime+ '.zip'; 
		    saveAs(content, filename);
		}); 
	}

}
