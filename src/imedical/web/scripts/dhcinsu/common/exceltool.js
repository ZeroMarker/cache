/// Excel���뵼��������
var INSUExcelTool=(function(){
	
	//˽�о�̬����----------------------------(�����ⷢ���ķ���)-----------------------------------
	//�������뵼����ʾ�� 
    function _InitProgress(InitMsg){
	    if ((InitMsg=="")||(InitMsg=="undefined")) {InitMsg="���ڵ�����..."}
    	if($('#loadLable').length!=0){
			$('#loadLable').html(InitMsg)  //��ʼ����
		}
		if($('#loadLable').length==0){
			$loadLable=$("<div id='loadLable' style='display:none;position:fixed;border-style: solid;border-width:1px;border-color:#46A3FF;background-color:#FFFFDF;width:400px;height:60px; z-index:10000;top:-200px;left:-100px;right:0px;bottom:0px;margin:auto;text-align:center;padding:20px;'>"+InitMsg+"</div>");
			$("body").append($loadLable);
		};
	}
	///���ļ�����ȡexcel����
	function _OpenAndGetExcelDataArr(){  //��ȡexcel����
		//var _this=this 
		//_this.InitProgress();  //��ʼ��������ʾ��
		return new Promise(function(resolve, reject) {
			$('#FileWindowDiv').empty();
			$FileWindowDiv=$("<a id='FileWindowDiv' class='FileWindow' style='display:none'>&nbsp;</a>");
			$("table").append($FileWindowDiv);
			$FileWindow=$("<input id='FileWindow' type='file' name='upload'/>");
			$("#FileWindowDiv").append($FileWindow);
			//$('#FileWindow1').val("");
	 		//ʵ����Ϣ�������ִ��		
	 		$('#FileWindow').select();
			if (!!window.ActiveXObject || "ActiveXObject" in window){  //ie֧��click
				   	_InitProgress("���ݵ����ʼ��...");  //������ʾ��  //ie ��clickǰ���� ���������Ⱦ������
					$('#loadLable').show();
					$('#FileWindow').click();  
					_GetExcelData().then(function(data){	
						resolve(data) 
					})

    		}else {   //�ȸ��������Ҫ��ӵ�onchange �¼�	
    			$('#FileWindow').click();  
    			$("#FileWindow").change(function(){
	    			_InitProgress("���ݵ����ʼ��...");  //������ʾ��  ��click�󴴽� ����ȡ��ѡ���رղ���
					$('#loadLable').show();
	    			_GetExcelData().then(function(data){
    				resolve(data) 
    				})
    			})	
    		} 		
    	}) 	
	}
	
	///��ȡexcel����
	function _GetExcelData(){
		return  new Promise(function(resolve, reject) {	
			$('#loadLable').html("���ݶ�ȡ�У����Ե�.....")  //��ʼ����
			var FilePath=$('#FileWindow').val();
			//$.messager.alert("��ʾ",FilePath)	
			if(!FilePath){
				$('#loadLable').hide()
				return;
			}
			var suffix=FilePath.substring(FilePath.lastIndexOf(".")+1,FilePath.length);
			if((suffix!="xls")&&(suffix!="xlsx")){
				$.messager.alert("��ʾ","�ļ����Ͳ���ȷ");
				$('#loadLable').hide()
				return 
			}
			var files = $('#FileWindow')[0].files;	        
			var fileReader = new FileReader();  //���� readAsBinaryString 	 	
	   	 	fileReader.readAsArrayBuffer(files[0]);// ��������ʽ
	   		//fileReader.readAsBinaryString(files[0]);// �Զ����Ʒ�ʽ���ļ�  //ie��֧��
	   		var fixdata=function(data) { //�ļ���תBinaryString  //��������   ��� xls ��ȡ���쳣������ bug
                var o = "",w = 10240;
                for(var l = 0; l < data.byteLength / w; ++l) {
                	o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w, l * w + w)));
                }
                o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w)));
                return o;
            }

	   		fileReader.onload = function(ev) {
	   			try {	               
	   				var data = ev.target.result;
	         		var workbook = XLSX.read(btoa(fixdata(data)), { type: 'base64'}),  //binary
	         		persons=[];
	         	} catch (e) {
	         		return $.messager.alert('�ļ����Ͳ���ȷ!');
	         	}
				// ����ÿ�ű��ȡ
				for (var sheet in workbook.Sheets) {
					if (workbook.Sheets.hasOwnProperty(sheet)) {
						worksheet = workbook.Sheets[sheet]['!ref'];
						persons = persons.concat(XLSX.utils.sheet_to_json(workbook.Sheets[sheet], {header:1,defval:""}));  //ת������Ϳ��ַ�����
        				break ;  //ֻȡ��һ�ű�
        			}
        		}
        		resolve(persons) 
        	}
        })
	}
	
	/**
	  shy 
	  ��ά�������json���鵼��excel 
	  Data ��ʽ json����--> [{"tset":"1","shy":"2"},{"tset":"1","shy":"2"}]
	 ��ά����-->  [[1,2,3,4,5],[2,3,45,6,5]]
	 */
	 function _Array2Excel(Data,fileName){
	 	if((Data=="")||(Data==null)||(!(Data instanceof Array))||((!(Data[0] instanceof Array))&&(!(typeof Data[0] == 'object'  )))){
	 		$.messager.alert("��ʾ","�赼��excel�������ʽ����,�����Ƕ�ά���������json����");
	 		return ;
	 	}
	 	var wopts = {bookType: 'xlsx',bookSST: false,type: 'binary'};
	 	var workBook = {SheetNames: ['Sheet1'],Sheets: {},Props: {}};
   		 //1��XLSX.utils.json_to_sheet(data) ����һ���������鲢����һ�����ڶ���ؼ����Զ����ɵġ����⡱�Ĺ�����Ĭ�ϵ���˳����ʹ��Object.keys���ֶεĵ�һ�γ���ȷ��
    	//2�������ݷ������workBook��Sheets�еȴ����
    	var mySkipHeader={
    		skipHeader:false
    	}
    	if(Data[0] instanceof Array){
	   		 mySkipHeader.skipHeader=true //�������ͨ���飬��һ���к�ȥ��
	   	}
	   	workBook.Sheets['Sheet1'] = XLSX.utils.json_to_sheet(Data,mySkipHeader)

		var changeData=function(s) {  //�ڲ��෽��
    		//�������ArrayBuffer����(es6) ��ò��øö���
    		if (typeof ArrayBuffer !== 'undefined') {
      			//1������һ���ֽڳ���Ϊs.length���ڴ�����
      			var buf = new ArrayBuffer(s.length);
      			//2������һ��ָ��buf��Unit8��ͼ����ʼ���ֽ�0��ֱ����������ĩβ
      			var view = new Uint8Array(buf);
    	  		//3������ָ��λ�õ��ַ���Unicode����
    	  		for (var i = 0; i != s.length; ++i) view[i] = s.charCodeAt(i) & 0xFF;
    	  			return buf;
    	  	} else {
    	  		var buf = new Array(s.length);
    	  		for (var i = 0; i != s.length; ++i) buf[i] = s.charCodeAt(i) & 0xFF;
    	  			return buf;
    	  	}
    	  }
		var SaveAs=function(obj, fileName) {//��Ȼ�����Զ���򵥵������ļ�ʵ�ַ�ʽ
			$('#loadLable').hide();    //ִ����ɺ�̨����󣬹ر���ʾ��
			if (window.navigator && window.navigator.msSaveOrOpenBlob) {
				
				window.navigator.msSaveOrOpenBlob(obj, fileName ? fileName + '.xlsx' : new Date().getTime() + '.xlsx');
			}else{
				var tmpa = document.createElement("a");
				tmpa.download = fileName ? fileName + '.xlsx' : new Date().getTime() + '.xlsx';
    			tmpa.href = URL.createObjectURL(obj); //��a��ǩ
    			tmpa.click(); //ģ����ʵ������
    			setTimeout(function () { //��ʱ�ͷ�
      				URL.revokeObjectURL(obj); //��URL.revokeObjectURL()���ͷ����object URL
      			}, 100);
    		}
    	}
    	
    	SaveAs(new Blob([changeData(XLSX.write(workBook, wopts))], { type: 'application/octet-stream' }),fileName)

    }
	
	
	/// ����˵��:��ȡ��Ҫ���������ݣ���������Excel��
	function _ExcelExport(DataSourceType, ClassName, MethodName, InputPam){
		_InitProgress("���ݻ�ȡ�У����Ե�.....");
		$('#loadLable').show();
		
		//��ȡ�ܵ���ϸ����
		var url=APP_PATH+"/com.ImportOrExportCtl/ExcelExportAjaxN";
		$.post(url,{
			DataSourceType:DataSourceType
			,ClassName:ClassName
			,MethodName:MethodName
			,InputPam:InputPam
		},function(data){
			if(data.Status>0){
				var DataRtnInfo=data.DataRtnInfo;       //����������Ϣ  ��ʽ:1��������^2����key^3global���Ƽ�ǰ׺
				var RtnArr=DataRtnInfo.split("^");
				var ALLSize=RtnArr[0];                  //��������
				var ExportDataID=RtnArr[1];             //����key
				var DataGlobalName=RtnArr[2];           //global���Ƽ�ǰ׺
				var rows=100;                //ÿ����ʾ��Ŀ
				var page=1;                  //��һҳ
				var OutData="";
				
				$('#loadLable').html(data.InfoMsg);        //��������չʾ
				_ExportDataByPage(rows, page, DataSourceType, ALLSize, ExportDataID, DataGlobalName, OutData);   //��ҳ��������
			}else{
				$.messager.alert('��ܰ��ʾ',data.ErrMsg);
				$('#loadLable').hide();
			}	
		},"json");
	}
	
	/// ����˵�����������ݷ�ҳ����
	function _ExportDataByPage(rows, page, DataType, ALLSize, ExportDataID, DataGlobalName, OutData){
		
		//��ȡ�ܵ���ϸ����
		var url=APP_PATH+"/com.ImportOrExportCtl/GetExportRowData";
		$.post(url,{
			rows:rows
			,page:page
			,DataType:DataType
			,ALLSize:ALLSize
			,ExportDataID:ExportDataID
			,DataGlobalName:DataGlobalName
		},function(data){
			if(data.Status>0){
				var EndPageFlg=data.EndPageFlg;            //�Ƿ�Ϊ���һҳ���ݱ�־
				$('#loadLable').html(data.InfoMsg);        //��������չʾ
				if(OutData==""){
					OutData=data.RowsArr;
				}else{
					OutData=OutData+","+data.RowsArr;
				}
				
				if(EndPageFlg!="1"){
					page=page+1;      //��ǰҳ��+1��Ϊ�´β�ѯ��ҳ��
					_ExportDataByPage(rows, page, DataType, ALLSize, ExportDataID, DataGlobalName, OutData);   //��ҳ��������
				}else{
					_InitProgress("����������ϣ���������excel�У��벻Ҫ�ر������.....");
					 setTimeout(function(){   //ie����Ⱦ����Ч�������ˣ����ǿ����Ⱦ��
						_Array2Excel(eval("["+OutData+"]"),"tmpExcelData");
						$('#loadLable').hide();
					 },50)
				}
			}else{
				$.messager.alert('��ܰ��ʾ',data.ErrMsg);
				$('#loadLable').hide();
			}	
		},"json");
	}
	
	/// ����˵������ά���ݵ�����ѭ������ϵͳ��
	/// ���˵����ClassName     --> ���������ݵ���
	///           MethodName    --> ���������ݵķ���
	///           GlobalDataFlg --> ���浽��ʱglobal�еı�־ 1 ��ʱglobal���� 0 ����ʱglobal����(��ʱ��ͷ������Ʊ��봫��)
	///           ExtStrPam     --> ��չ����
	///           UserDr        --> ����Ĳ���Ա
	///           Rows          --> ��ά��������
	///           RecIndex      --> ����ĵڼ�������(��Ŵ�1��ʼ)
	///           ErrMsg        --> ������Ϣ
	///           GlobalDataKey --> �������ݼ�¼�����globalkey
	///           SumNum        --> �ɹ�����
	///           ErrNum        --> ʧ������
	///           StartRow      --> ����һ�п�ʼ����(������ӵڶ��п�ʼ����)
	function _ImportRowsData(ClassName, MethodName, GlobalDataFlg, ExtStrPam, UserDr, Rows, RecIndex, ErrMsg, GlobalDataKey, SumNum, ErrNum, StartRow, RtnFun){
		
		var RowNums=Rows.length;      //��������Ŀ
		if ((RowNums<1)||(RecIndex>RowNums)) {
			$('#loadLable').hide();
			return 0;
		}
		
		var RowIndex=RecIndex-1;      //������� �������ݵ������һ��
		var RowData=Rows[RowIndex];   //������(һά����)
		var ColNums=RowData.length;   //����Ŀ
		
		var ImportNums=RowNums-(StartRow-1)   //��Ч��������
		var ImportIndex=RecIndex-(StartRow-1) //�����������
		var BaseImportInfo="���ε�������ݹ���"+ImportNums+"��"+ColNums+"��.";
		
		/// ��֯�����ݸ�ʽ Ϊ �ϼ�ͷ�ָ�������ַ���
		var RowDataInfo="";
		var ColVal="";
		for (var colIndex=0; colIndex<ColNums; colIndex++){
			ColVal=RowData[colIndex];   //������
			if(colIndex==0){
				RowDataInfo=ColVal;
			}else{
				RowDataInfo=RowDataInfo+"^"+ColVal;
			}
		}
		
		/*
		if(RowDataInfo==""){
			$('#loadLable').hide();
			return 0;
		}
		*/
		
		//alert("RowDataInfo="+RowDataInfo);
		
		var RowImportMsg=BaseImportInfo+"<br/>"+"��"+ImportIndex+"�е��뿪ʼ..."
		$('#loadLable').html(RowImportMsg)
		
		var url=APP_PATH+"/com.ImportOrExportCtl/ExcelImportAjaxN";
		$.post(url,{
			ClassName:ClassName
			,MethodName:MethodName
			,RowIndex:RecIndex
			,RowDataInfo:RowDataInfo
			,UserDr:UserDr
			,GlobalDataFlg:GlobalDataFlg
			,ExtStr:ExtStrPam
			,GlobalDataKey:GlobalDataKey
		},function(data){
			var ResultDesc="";
			if(data.Status=="-100"){                //�������ܼ��������ߵĴ���ʱ,ֹͣѭ��
				$('#loadLable').hide();
				$.messager.alert("��ܰ����",data.ErrMsg+"��"+ImportIndex+"��"+RowDataInfo);
				return 0;
			}
			
			if(data.Status>0){
				var GlobalDataKey=data.GlobalDataKey;       //����key
				SumNum=SumNum+1;    //�ɹ�����+1
				ResultDesc="�ɹ�";
			}else{
				ErrNum=ErrNum+1     //ʧ������+1
				if(ErrMsg==""){
					ErrMsg=data.ErrMsg;
				}else{
					ErrMsg=ErrMsg+"\n"+data.ErrMsg;
				}
				ResultDesc="ʧ��";
			}
			
			RowImportMsg=BaseImportInfo+"<br/>"+"��"+ImportIndex+"�е������["+ResultDesc+"].";
			$('#loadLable').html(RowImportMsg)
			
			//�ж��Ƿ�Ϊ���һ������
			if(RecIndex==RowNums){
				$('#loadLable').hide();
				var ResultMsgInfo=BaseImportInfo+"�ɹ�"+SumNum+"��,ʧ��"+ErrNum+"��.";
				$.messager.alert('��ʾ',ResultMsgInfo);

				
				//�лص�������ʱ��,���ûص����������Ϊ����ֵ
				if(typeof(RtnFun)!='undefined'){
					RtnFun();
				}
			}else{
				RecIndex=RecIndex+1   //�������һ�����ݵ�ʱ��ݹ���õ�������
				_ImportRowsData(ClassName, MethodName, GlobalDataFlg, ExtStrPam, UserDr, Rows, RecIndex, ErrMsg, GlobalDataKey, SumNum, ErrNum, StartRow, RtnFun);  //������һ������
			}
				
		},"json");
		
		
	}
	
	//�����෽��
	function _tool(){
	}
	
	//����ԭ�ͷ���(����ʹ�÷���)====================================================================================
	_tool.prototype={
		
		/// ����˵��: Excel���ݵ��빲ͨ����
		/// ���˵����ClassName     --> ���������ݵ���
		///           MethodName    --> ���������ݵķ���
		///           GlobalDataFlg --> ���浽��ʱglobal�еı�־ 1 ��ʱglobal���� 0 ����ʱglobal����(��ʱ��ͷ������Ʊ��봫��)
		///           ExtStrPam     --> ��չ����
		///           UserDr        --> ����Ĳ���Ա
		///           StartRow      --> ����һ�п�ʼ����(������ӵڶ��п�ʼ����)
		///           RtnFun        --> �ص�����
		/// �ر�˵�������������ݵķ��������ʽ[SaveImportData(RowDataInfo As %String, UserDr As %String, ByRef info As %String, ExtStr As %String)]
		ExcelImport:function(ClassName, MethodName, GlobalDataFlg, ExtStrPam,UserDr, StartRow, RtnFun){
			var ArgLen=arguments.length;         //��������
			if(ArgLen<3){
				$.messager.alert('��ܰ��ʾ',"������������,��˶�!");
				return 0;
			}
			if(GlobalDataFlg=="0"){   //����ʱglobal���봫����ͷ�������
				if((ClassName=="")||(MethodName=="")){
					$.messager.alert('��ܰ��ʾ',"����ʱglobal�������,��Ҫ���������ͷ�����.");
					return 0;
				}
			}
			
			//����Ĭ��ֵ
			if(ArgLen<4){ ExtStrPam=""; }
			if(ArgLen<5){ UserDr=""; }
			if(ArgLen<6){ StartRow=2; }
			if(StartRow==""){ StartRow=2}; //������ɿ� 

			_OpenAndGetExcelDataArr().then(function(dataArr){   //��ȡexcel����
				_ImportRowsData(ClassName,MethodName,GlobalDataFlg, ExtStrPam, UserDr, dataArr, StartRow, "", "", 0, 0, StartRow, RtnFun)
			})
		},
		
		/// ����˵��: query����ʱglobal����ʱglobal���ݵ���Excel�Ĺ�ͨ����
		/// ���˵������һ������ --> ��ѯ����Դ����(0 query��ѯ��� 1 global�б����� 2 global^�ָ������ )
		///           �ڶ������� --> ��ѯ���ݵ�������
		///           ���������� --> ��ѯ���ݵķ������ƻ���query����
		///           ���ĸ�֮��Ĳ��� --> ��˳�����ѯ�����Ĳ���
		/// �ر�˵�����������ֵ����ʱglobal���ݱ��Ᵽ�������ҵĸ�ʽ�� s:index>0 ^TMPINSUQC("RuleLocGrpInfo", RuleLocGrpID, "title")=$lb("1","2","3")
		///           ��title�ڵ��б���
		///           ʹ�þ�������[js/dictool/reprulelocgroup.js]
		ExcelExport:function(){
			var ArgLen=arguments.length;         //��������
			if (ArgLen<4) {
				$.messager.alert('��ܰ��ʾ',"���ò�����������ȷ,����ϵ������Ա!");

				return 0;
			}
			
			var DataSourceType=arguments[0];     //��ѯ����Դ����(0 query��ѯ��� 1 �б����� 2 ^�ָ������ )
			var ClassName=arguments[1];          //��ѯ���ݵ�������
			var MethodName=arguments[2];         //��ѯ���ݵķ������ƻ���query����
			var InputPam="";                     //�����Ļ���query�Ĳ���ƴ��(���շ���ִ�еĲ���˳��ƴ�� ��","�ŷָ�ָ��������)
			var ArgPamVal="";
			//��֯��ѯ����
			for(var ArgIndex=3; ArgIndex<ArgLen; ArgIndex++){
				ArgPamVal=arguments[ArgIndex];
				if(ArgIndex==3){
					InputPam=ArgPamVal
				}else{
					InputPam=InputPam+","+ArgPamVal;
				}
			}
			_ExcelExport(DataSourceType, ClassName, MethodName, InputPam);
		}
		
		/// ����˵��: ����json�������js�Ķ�ά����
		/// ���˵����JsonArrr --> json������߶�ά����
		/// ʹ�ó���: ����datagridview�ĵ�ǰҳ����
		///           json�����������ӣ�[["PatAdmDr":"1","Patname":"����1","patNo":"3"],["PatAdmDr":"2","Patname":"����2","patNo":"2"]]
		///           ��ά��������    : [["\"1"\","2","3"],["4","5","6"]] 
		,ExcelExportOfArrData:function(Data,Header,FileName){
			 //JsonArrr.unshift();
			 var DataO=eval(Data);
			 var Header= Header || "";
			 if (Header!=""){
			  DataO.unshift(Header);
			 }
			 var FileName = FileName || "tmpExcelArrData"
			_Array2Excel(DataO,FileName);
			 if (Header!=""){
			  DataO.shift();
			 }
		}
		
	}
	
	//������
	return _tool;
})()