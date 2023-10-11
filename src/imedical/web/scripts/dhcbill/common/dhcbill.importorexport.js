// dhcbill/common/dhcbill.importorexport.js
document.write("<script language = javascript src = 'https://cdn.polyfill.io/v2/polyfill.min.js'></script>");
document.write("<script language = javascript src = '../insuqc/js/lib/xlsx.core.min.js'></script>");
//<script type="text/javascript" src="../insuqc/js/lib/xlsx.core.min.js"></script>
//https://cdn.polyfill.io/v2/polyfill.min.js

/// ����˵�����������ݹ�ͨjs����
/// ���˵����GlobalDataFlg --> ��ʱ���ݱ�־ 1 ���浽��ʱglobal���� 0 ���浽����(��Ҫ���������ͷ�����)
///                 ClassName      --> ��������
///                 MethodName  --> ������
///                 ExtStr              --> ���ò���(ҽԺ����^ҽ������)
/// �޸����������Ʒ� 2019 05 07 ������
function ExcelImport(GlobalDataFlg, ClassName, MethodName, ExtStrPam,RtnFun){
	_OpenAndGetExcelDataArr().then(function(dataArr){   //��ȡexcel����
		_ImportRowsData(ClassName,MethodName,GlobalDataFlg, ExtStrPam, dataArr, 2, "", "", 0, 0, 2, RtnFun)
	})
}

/// ����˵��������������ѿ򴴽�
function loadLableInit(){
	//����������ѿ򴴽�
	if($('#loadLable').length==0){
		$loadLable=$("<div id='loadLable' class='loadLablestyle'>���ڵ���</div>");
		$("body").append($loadLable);
	};
}

function SetValue(value)
{
	if(value == undefined)
	{
		value="";
	}
	
	value=value.toString().replace(/\"/g, "");
	value=value.toString().replace(/\?/g,"");
	return value;
}

//���ļ��У�ѡ���ļ��Ĺ�ͨ����
function FileOpenWindow(){
	if($('#FileWindowDiv').length==0){
		$('#FileWindowDiv').empty();
		
		$FileWindowDiv=$("<a id='FileWindowDiv' class='FileWindow' style='display:none'>&nbsp;</a>");
		$("body").append($FileWindowDiv);
		$FileWindow=$("<input id='FileWindow' type='file' name='upload'/>");
		$("#FileWindowDiv").append($FileWindow);
	}
	$('#FileWindow').val("");
	$('#FileWindow').select();
	$(".FileWindow input").click();
	var FilePath=$('#FileWindow').val();
	//alert(FilePath);
	return FilePath;
}

$(".FileWindow").on("change","input[type='file']",function(){
	//alert(3233);
	var filePath=$(this).val();
	alert("filePath="+filePath);
});

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
         		var workbook = XLSX.read(btoa(fixdata(data)), { type: 'base64'}),  // binary	base64
         		persons=[];
         	} catch (e) {
	         	$('#loadLable').hide();
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
/// ����˵������ά���ݵ�����ѭ������ϵͳ��
/// ���˵����ClassName     --> ���������ݵ���
///           MethodName    --> ���������ݵķ���
///           GlobalDataFlg --> ���浽��ʱglobal�еı�־ 1 ��ʱglobal���� 0 ����ʱglobal����(��ʱ��ͷ������Ʊ��봫��)
///           ExtStrPam     --> ��չ����
///           Rows          --> ��ά��������
///           RecIndex      --> ����ĵڼ�������(��Ŵ�1��ʼ)
///           ErrMsg        --> ������Ϣ
///           GlobalDataKey --> �������ݼ�¼�����globalkey
///           SumNum        --> �ɹ�����
///           ErrNum        --> ʧ������
///           StartRow      --> ����һ�п�ʼ����(������ӵڶ��п�ʼ����)
function _ImportRowsData(ClassName, MethodName, GlobalDataFlg, ExtStrPam, Rows, RecIndex, ErrMsg, GlobalDataKey, SumNum, ErrNum, StartRow, RtnFun){
	
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
	
	$cm({
		ClassName:"BILL.EINV.BL.COM.ImportOrExportCtl"
		,MethodName:"ExcelImportAjaxN"
		,ImportClass:ClassName
		,ImportMethod:MethodName
		,RowIndex:RecIndex
		,RowDataInfo:RowDataInfo
		,UserDr:session['LOGON.USERID']
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
		}else if (data.Status != "EMPTY"){
			ErrNum=ErrNum+1     //ʧ������+1
			if(ErrMsg==""){
				ErrMsg=data.ErrMsg;
			}else{
				ErrMsg=ErrMsg+"\n"+data.ErrMsg;
			}
			ResultDesc="ʧ��";
		}else{
			ResultDesc="������";
		}
		
		RowImportMsg=BaseImportInfo+"<br/>"+"��"+ImportIndex+"�е������["+ResultDesc+"].";
		$('#loadLable').html(RowImportMsg)
		
		//�ж��Ƿ�Ϊ���һ������
		if(RecIndex==RowNums){
			$('#loadLable').hide();
			var empty = ImportNums - SumNum - ErrNum;
			var ResultMsgInfo=BaseImportInfo+"�ɹ�"+SumNum+"��,ʧ��"+ErrNum+"��,������"+empty+"��.";
			$.messager.alert('��ʾ',ResultMsgInfo);

			//�лص�������ʱ��,���ûص����������Ϊ����ֵ
			if(typeof(RtnFun)!='undefined'){
				RtnFun();
			}
		}else{
			RecIndex=RecIndex+1   //�������һ�����ݵ�ʱ��ݹ���õ�������
			_ImportRowsData(ClassName, MethodName, GlobalDataFlg, ExtStrPam, Rows, RecIndex, ErrMsg, GlobalDataKey, SumNum, ErrNum, StartRow, RtnFun);  //������һ������
		}
			
	},"json");
	
	
}