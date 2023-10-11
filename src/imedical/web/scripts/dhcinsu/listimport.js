//<!-- 
// * FileName:	listimport.js
// * User:		Hanzh 
// * Date:		2022-07-19 
// * Description: ҽ��excelģ�嵼��
//-->
var GV = {
	LISTTYPE: "",
	CALSSNAME: "",
	METHODNAME: ""
}
//readAsBinaryString function is not defined in IE
//Adding the definition to the function prototype
if (!FileReader.prototype.readAsBinaryString) {
	console.log('readAsBinaryString definition not found');
	FileReader.prototype.readAsBinaryString = function (fileData) {
		var binary = '';
		var pk = this;
		var reader = new FileReader();
		reader.onload = function (e) {
			var bytes = new Uint8Array(reader.result);
			var length = bytes.byteLength;
			for (var i = 0; i < length; i++) {
				var a = bytes[i];
				var b = String.fromCharCode(a)
				binary += b;
			}
			pk.content = binary;
			$(pk).trigger('onload');
		}
		reader.readAsArrayBuffer(fileData);
	}
}
var init = function () {
	var ClearMain = function () {
		$('#ListType').combobox('clear');
		$('#File').filebox('clear');
		$('#file').filebox('disable');
        $("#ImportBT").linkbutton('disable');
	}
	var LoadBtn = $('#LoadBT').menubutton({ menu: '#mm-DownLoad' });
	$(LoadBtn.menubutton('options').menu).menu({
		onClick: function (item) {
			var BtnName = item.name;
			if (BtnName == 'LoadMoudle') {//����������ģ��
				var ListType = $HUI.combobox("#ListType").getValue();
				if (ListType == "") {
			        $.messager.alert('��ʾ', '����ѡ��Ŀ¼����!','error');
					return;
				}
				
				// var filename=ListType+".xls";
				// window.open("../scripts/dhcinsu/Excel/"+filename, "_blank");

				var xmlhttp = new XMLHttpRequest()
				yourFileURL="../scripts/dhcinsu/Excel/"+ListType+".xls";
				xmlhttp.open("GET",yourFileURL,false); 
				xmlhttp.send(); 
				if(xmlhttp.readyState==4){    

					if(xmlhttp.status==200){
						window.open(yourFileURL,"_blank"); //url����  
					} 
					else{
						window.open("../scripts/dhcinsu/Excel/"+ListType+".xlsx","_blank"); //url������
					} 
				}
				
			} 
			else if (BtnName == 'LoadMouDesc') {//����ģ��˵��
				window.open("../scripts/dhcinsu/Excel/readMe.txt", "_blank");
			}
		}
	});
	$('#File').filebox({
		buttonText: 'ѡ��',
		prompt: 'excel�ļ���*.xls,*.xlsx',
		accept: 'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
		width: 300,
		onChange: function(newVal,oldVal) {
			if(newVal!=""){
        		$("#ImportBT").linkbutton('enable');
			}
		},
	});
	$('#ListType').combobox({
		data: [
			{ 'RowId': 'HILIST', 'Description': 'ҽ��Ŀ¼����'},
			{ 'RowId': 'HILISTCON', 'Description': 'ҽ��Ŀ¼���յ���'},
			{ 'RowId': 'DIAG', 'Description': 'ҽ����ϵ���'},
			{ 'RowId': 'DIAGCON', 'Description': 'ҽ����϶��յ���'},
			{ 'RowId': 'OPRN', 'Description': 'ҽ����������'},
			{ 'RowId': 'OPRNCON', 'Description': 'ҽ���������յ���'},
			{ 'RowId': 'INSUDATA', 'Description': 'ҽ�������ϴ�����'}
		],
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function (rec) {
			if(rec.RowId!=""){
				$('#file').filebox('enable');
				GV.LISTTYPE=rec.RowId;
				switch(rec.RowId){
					case "HILIST":
						GV.CALSSNAME="web.INSUTarItemsCom";
						GV.METHODNAME="Update";
						break;
					case "HILISTCON":
						GV.CALSSNAME="web.INSUTarContrastCom";
						GV.METHODNAME="SaveInCont";
						break;
					case "DIAG":
						GV.CALSSNAME="web.INSUDiagnosis";
						GV.METHODNAME="SaveDiag";
						break;
					case "DIAGCON":
						GV.CALSSNAME="web.INSUDiagnosis";
						GV.METHODNAME="SaveInContNew";
						break;
					case "OPRN":
						GV.CALSSNAME="INSU.MI.DTO.OPRNOPRTLIST";
						GV.METHODNAME="SaveInsuOper";
						break;
					case "OPRNCON":
						GV.CALSSNAME="web.INSUOPERContrastCtl";
						GV.METHODNAME="SaveInOperCon";
						break;
				}
			}
		}
	});
	$HUI.linkbutton('#ImportBT', {
		onClick: function () {
			InItmImpt();
		}
	});
	function to_json(workbook) {
		//ȡ ��һ��sheet ����
		var jsonData = {};
		var sheet2JSONOpts = {
			defval: ''		//����Ϊ��ʱ��Ĭ��ֵ
		};
		var result = XLSX.utils.sheet_to_json(workbook.Sheets[workbook.SheetNames[0]], sheet2JSONOpts);
		jsonData.rows = result;
		jsonData.total = result.length;
		return jsonData;	//JSON.stringify(jsonData);
	}
	//Ŀ¼����
	function InItmImpt(){
		var wb;   //wookbook
		var ListType=$('#ListType').combobox("getValue");
		if (ListType=="") {
	        $.messager.alert('��ʾ', 'Ŀ¼���Ͳ���Ϊ��!','error');
			return;
		}
		var filelist = $('#File').filebox("files");
		if (filelist.length == 0) {
	        $.messager.alert('��ʾ', '��ѡ��Ҫ�����Excel!','error');
			return;
		}
		var file = filelist[0];
		var reader = new FileReader();
		reader.onload = function (e) {
			if (reader.result) { reader.content = reader.result; }
			//In IE browser event object is null
			var data = e ? e.target.result : reader.content;
			wb = XLSX.read(data, {
				type: 'binary'
			});
			var json = to_json(wb);
			var rowCnt=json.rows.length;
			$.messager.progress({
		        title: "��ʾ",
		        msg: '���ݵ���',
		        text: '�����У�����'+rowCnt+'��'
			}); 
			$.ajax({
				async : true,
				complete : function () {
					ItmJsonSave(json);
				}
			});
		}
		reader.readAsBinaryString(file);
	}
	
	//���ݱ���
	function ItmJsonSave(json)
	{
		//��ȡ��������
		var ErrMsg = "";     //��������
	    var errRowNums = 0;  //��������
	    var sucRowNums = 0;  //����ɹ�������
		var rows=json.rows.length;
		try{
			if (GV.LISTTYPE=="INSUDATA"){
				var PortListID = "";
				var PortNodeId = "";
				for (i = 0; i <= rows-1; i++) {
					// 1.�ȵ��� portlist
					if(i==0){
						var editorRow = {
								HOSPID: json.rows[i]["Ժ������Ϊ��"],
								TYPE: json.rows[i]["PORTLISTTYPE"],
								HITYPE: json.rows[i]["ҽ�����Ͳ���Ϊ��"],
								INFNO : json.rows[i]["PORTLISTINFNO"],
								INFNAME : json.rows[i]["PORTLISTINFNAME"],
								CONTENTTYPE : json.rows[i]["PORTLISTCONTENTTYPE"],
								SIGNTYPE : json.rows[i]["PORTLISTSIGNTYPE"] ,
								CHKFLAG : json.rows[i]["PORTLISTCHKFLAG"] ,
								EFFTFLAG : json.rows[i]["PORTLISTEFFTFLAG"],
								URL : json.rows[i]["PORTLISTURL"],
								NODECODE : json.rows[i]["PORTLISTNODECODE"],
								HISVER : json.rows[i]["PORTLISTHISVER"],
								CLASSNAME : json.rows[i]["PORTLISTCLASSNAME"],
								METHODNAME: json.rows[i]["PORTLISTMETHODNAME"],
								OUTNODECODE : json.rows[i]["PORTLISTOUTNODECODE"] ,
								BUILDINPUT : json.rows[i]["PORTLISTBUILDINPUT"] ,
								ROWID : ''
							}
						var InJson = JSON.stringify(editorRow);
						InJson.replace(undefined,'');
						InJson.replace('undefined','');
						// ##class(INSU.MI.PortListCom).Save(InJson)
						var rtn = $.m({ClassName: "INSU.MI.PortListCom", MethodName: "Save", InJson: InJson,SessionStr: session['LOGON.USERID']}, false);
						if(rtn.split('^')[0] == '0'){
							PortListID = rtn.split('^')[1];	
						}else{
							$.messager.alert('��ʾ','����ӿ�ʧ��','error');
							ErrMsg = savecode.split('^')[0];
							return false;   		
						}
					}
					// 2.����PortNode
					if( json.rows[i][16] && json.rows[i][16] !=""){
						var editorRow = {
								NODECODE: json.rows[i]["PORTNODENODECODE"],
								NODENAME: json.rows[i]["PORTNODENODENAME"],
								NODETYPE: json.rows[i]["PORTNODENODETYPE"],
								CLASSNAME: json.rows[i]["PORTNODECLASSNAME"],
								METHODNAME: json.rows[i]["PORTNODEMETHODNAME"],
								METHODTYPE: json.rows[i]["PORTNODEMETHODTYPE"],
								CONFLAG: json.rows[i]["PORTNODECONFLAG"],
								SUBFLAG: json.rows[i]["PORTNODESUBFLAG"],
								SEQ: json.rows[i]["PORTNODESEQ"],
								PARNODETYPE: json.rows[i]["PORTNODEPARNODETYPE"],
								PARID:PortListID,
								ROWID : ''
							}
						var InJson = JSON.stringify(editorRow);
						InJson.replace(undefined,'');
						InJson.replace('undefined','');
						var savecode = $.m({ClassName: "INSU.MI.PortNodeCom", MethodName: "Save", InJson: InJson,SessionStr: session['LOGON.USERID']}, false);
						if(savecode.split('^')[0] == '0'){
							PortNodeId = savecode.split('^')[1];
						}else{
							$.messager.alert('��ʾ','����ڵ�ʧ��','error');
							ErrMsg = savecode.split('^')[0];
							return false;   		
						}
					}
					//3.����PortInArgs
					if( json.rows[i][26] && json.rows[i][26] !=""){
						var editorRow = {
								ARGCODE: json.rows[i]["INARGSARGCODE"],
								ARGNAME: json.rows[i]["INARGSARGNAME"],
								CONTYPE: json.rows[i]["INARGSCONTYPE"],
								CONINFO : json.rows[i]["INARGSCONINFO"],
								ARGTYPE : json.rows[i]["INARGSARGTYPE"],
								MUSTLFLAG : json.rows[i]["INARGSMUSTLFLAG"],
								MAXLENG : json.rows[i]["INARGSMAXLENG"] ,
								SUBNODE : json.rows[i]["INARGSSUBNODE"] ,
								SUBNAME : json.rows[i]["INARGSSUBNAME"] ,
								SEQ : json.rows[i]["INARGSSEQ"],
								CONINFODESC : json.rows[i]["INARGSCONINFODESC"],
								PARNODETYPE : json.rows[i]["INARGSPARNODETYPE"] ,
								CODEFLAG : json.rows[i]["INARGSCODEFLAG"],
								DEFVALUE: json.rows[i]["INARGSDEFVALUE"],
								CONINFODEMO : json.rows[i]["INARGSCONINFODEMO"] ,
								EFFTFLAG :json.rows[i]["INARGSEFFTFLAG"],
								CONINFOSOURCE:json.rows[i]["INARGSCONINFOSOURCE"],
								DICCODE:json.rows[i]["INARGSDICCODE"],
								LOCALPARCODE:json.rows[i]["INARGSLOCALPARCODE"],
								PARID:PortNodeId,
								ROWID : ''
							}
						var InJsonStr = JSON.stringify(editorRow);
						InJsonStr.replace(undefined,'');
						InJsonStr.replace('undefined','');
						//var savecode = $.m({ClassName: "INSU.MI.PortInArgsCom", MethodName: "Save", InJson: InJsonStr,SessionStr: session['LOGON.USERID']}, false);
						var savecode =tkMakeServerCall("INSU.MI.PortInArgsCom","Save",InJsonStr,session['LOGON.USERID']);
						if (savecode.split('^')[0] == '0'){
							
						}else{
							$.messager.alert('��ʾ','����ڵ�ʧ��','error');
							ErrMsg = savecode.split('^')[0];
							return false;   		
						}
					}
				}
			}else{
				for (i = 0; i < rows; i++){
				var rowArr=json.rows[i];
				var UpdateStr="";
				for(var key in rowArr){
					//if(key.indexOf("EMPTY")!=-1){break;}
					UpdateStr=UpdateStr+"^"+rowArr[key];
				}
				if(GV.LISTTYPE=="HILIST"){
					var savecode = tkMakeServerCall(GV.CALSSNAME, GV.METHODNAME,"", "",UpdateStr);
				}else{
					var savecode = tkMakeServerCall(GV.CALSSNAME, GV.METHODNAME,UpdateStr);
				}
			    if (savecode == null || savecode == undefined) savecode = -1
			    
			    if (savecode >= 0) {
			        sucRowNums = sucRowNums + 1;
			    } else {
			        errRowNums = errRowNums + 1;
			        if (ErrMsg == "") {
			            ErrMsg = i+1+":"+savecode;
			        } else {
			            ErrMsg = ErrMsg + "<br>" + i+1+":"+savecode;
			        }
			    }
			}
			}
			
			if (ErrMsg == "") {
			    $.messager.progress("close");
				$.messager.alert('��ʾ', '�������,����'+(rows-errRowNums)+"��");
			} else {
			   $.messager.progress("close");
			     var tmpErrMsg = "����ɹ���"+sucRowNums +"����ʧ�ܣ�"+errRowNums+"����";
			     tmpErrMsg = tmpErrMsg + "<br>ʧ�������кţ�<br>"+ ErrMsg;
			    $.messager.alert('��ʾ', tmpErrMsg,'info');
			}
			return ;
		}
		catch(ex)
		{
		  $.messager.progress("close");
		  $.messager.alert('��ʾ', '���ݵ����쳣��'+ex.message,'error')
		  return ;
		}
		return ;
	}
	
	$HUI.linkbutton('#ClearBT', {
		onClick: function () {
			ClearMain();
		}
	});
	
	ClearMain();
}
$(init);



